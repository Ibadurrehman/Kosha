import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/app_database.dart';
import '../../../core/services/notifications/reminder_scheduler.dart';
import '../../../core/services/notifications/scheduled_reminder.dart';
import '../../../core/utils/clock.dart';
import '../../tasks/domain/entities/activity_entry.dart';
import '../domain/entities/custom_record.dart';
import '../domain/entities/record_template.dart';
import '../domain/record_reminder.dart';
import '../domain/record_repository.dart';

part 'record_repository_impl.g.dart';

/// `ActivityEntries.ownerType` for a record; templates keep no history of
/// their own, because every change to one is visible as the shape of the
/// records under it.
const String customRecordOwnerType = 'custom_record';

/// SQLite-backed custom records.
///
/// Every write goes through here so the row change and the reminder the
/// operating system holds stay together, the rule `DriftDocumentRepository`
/// sets out.
///
/// Every *read* of records joins `RecordTemplates` and drops rows whose
/// template is deleted. That is what makes deleting a template one row write
/// and its undo another, instead of a cascade across every record it owns —
/// the same join-and-filter shape `watchUtilities` uses to hide a deleted
/// bill's tile.
class DriftRecordRepository implements RecordRepository {
  DriftRecordRepository(this._db, this._clock, this._scheduler);

  static const Uuid _uuid = Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final ReminderScheduler _scheduler;

  @override
  Stream<List<RecordTemplate>> watchTemplates() {
    final query = _db.select(_db.recordTemplates)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch().map((rows) => rows.map(_toTemplate).toList());
  }

  @override
  Stream<RecordTemplate?> watchTemplateById(String id) {
    final query = _db.select(_db.recordTemplates)
      ..where((t) => t.id.equals(id) & t.deletedAt.isNull());
    return query
        .watchSingleOrNull()
        .map((row) => row == null ? null : _toTemplate(row));
  }

  @override
  Future<RecordTemplate?> findTemplateById(String id) async {
    final row = await (_db.select(_db.recordTemplates)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toTemplate(row);
  }

  @override
  Future<RecordTemplate> createTemplate(NewRecordTemplate draft) async {
    final now = _clock.now();
    final template = RecordTemplate(
      id: _uuid.v4(),
      name: draft.name,
      iconKey: draft.iconKey,
      fields: draft.fields,
      spaceId: draft.spaceId,
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.recordTemplates).insert(_toTemplateRow(template));
    return template;
  }

  @override
  Future<RecordTemplate> editTemplate(
    String id, {
    String? name,
    String? iconKey,
    List<RecordField>? fields,
    String? spaceId,
    bool clearSpaceId = false,
  }) async {
    await (_db.update(_db.recordTemplates)..where((t) => t.id.equals(id)))
        .write(
      RecordTemplatesCompanion(
        name: name == null ? const Value.absent() : Value(name),
        iconKey: iconKey == null ? const Value.absent() : Value(iconKey),
        fields: fields == null
            ? const Value.absent()
            : Value(encodeRecordFields(fields)),
        spaceId: clearSpaceId
            ? const Value(null)
            : (spaceId == null ? const Value.absent() : Value(spaceId)),
        updatedAt: Value(_clock.now()),
      ),
    );
    return _requireTemplate(id);
  }

  @override
  Future<void> deleteTemplate(String id) async {
    final now = _clock.now();
    await (_db.update(_db.recordTemplates)..where((t) => t.id.equals(id)))
        .write(
      RecordTemplatesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
    // The records stay exactly as they are — only their reminders go, because
    // a deleted record type must not keep speaking. Restoring re-schedules
    // every one that is still in the future.
    for (final record in await _recordsOf(id)) {
      await _scheduler.cancel(ReminderKind.customRecord, record.id);
    }
  }

  @override
  Future<void> restoreTemplate(String id) async {
    await (_db.update(_db.recordTemplates)..where((t) => t.id.equals(id)))
        .write(
      RecordTemplatesCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_clock.now()),
      ),
    );
    final template = await _requireTemplate(id);
    for (final record in await _recordsOf(id)) {
      await _syncReminder(record, templateName: template.name);
    }
  }

  @override
  Stream<List<CustomRecord>> watchRecords(String templateId) {
    final query = _liveRecords()
      ..where(_db.customRecords.templateId.equals(templateId))
      ..orderBy([OrderingTerm.desc(_db.customRecords.createdAt)]);
    return query.watch().map(_readRecords);
  }

  @override
  Stream<CustomRecord?> watchRecordById(String id) {
    final query = _liveRecords()..where(_db.customRecords.id.equals(id));
    return query.watch().map((rows) {
      final records = _readRecords(rows);
      return records.isEmpty ? null : records.first;
    });
  }

  @override
  Future<CustomRecord?> findRecordById(String id) async {
    final row = await (_db.select(_db.customRecords)
          ..where((r) => r.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toRecord(row);
  }

  @override
  Future<CustomRecord> createRecord(NewCustomRecord draft) async {
    final template = await _requireTemplate(draft.templateId);
    final now = _clock.now();
    final record = CustomRecord(
      id: _uuid.v4(),
      templateId: draft.templateId,
      title: draft.title,
      values: pruneValues(
        draft.values,
        template.fields.map((field) => field.key),
      ),
      statusLabel: draft.statusLabel,
      renewalDate: draft.renewalDate,
      documentId: draft.documentId,
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.customRecords).insert(_toRecordRow(record));
    await _log(record.id, ActivityEvent.created);
    await _syncReminder(record, templateName: template.name);
    return record;
  }

  @override
  Future<CustomRecord> editRecord(
    String id, {
    String? title,
    Map<String, String>? values,
    String? statusLabel,
    bool clearStatusLabel = false,
    DateTime? renewalDate,
    bool clearRenewalDate = false,
    String? documentId,
    bool clearDocumentId = false,
  }) async {
    final existing = await _requireRecord(id);
    final template = await _requireTemplate(existing.templateId);
    // Values arriving from the editor are pruned to the template's current
    // fields, which is the one moment a field removed in the builder actually
    // costs its data — by then the user has seen the editor without it.
    final pruned = values == null
        ? null
        : pruneValues(values, template.fields.map((field) => field.key));

    await (_db.update(_db.customRecords)..where((r) => r.id.equals(id))).write(
      CustomRecordsCompanion(
        title: title == null ? const Value.absent() : Value(title),
        values:
            pruned == null ? const Value.absent() : Value(encodeRecordValues(pruned)),
        statusLabel: clearStatusLabel
            ? const Value(null)
            : (statusLabel == null ? const Value.absent() : Value(statusLabel)),
        renewalDate: clearRenewalDate
            ? const Value(null)
            : (renewalDate == null ? const Value.absent() : Value(renewalDate)),
        documentId: clearDocumentId
            ? const Value(null)
            : (documentId == null ? const Value.absent() : Value(documentId)),
        updatedAt: Value(_clock.now()),
      ),
    );

    final updated = await _requireRecord(id);
    await _log(id, ActivityEvent.edited);
    await _syncReminder(updated, templateName: template.name);
    return updated;
  }

  @override
  Future<void> deleteRecord(String id) async {
    final now = _clock.now();
    await (_db.update(_db.customRecords)..where((r) => r.id.equals(id))).write(
      CustomRecordsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
    await _log(id, ActivityEvent.deleted);
    await _scheduler.cancel(ReminderKind.customRecord, id);
  }

  @override
  Future<void> restoreRecord(String id) async {
    await (_db.update(_db.customRecords)..where((r) => r.id.equals(id))).write(
      CustomRecordsCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_clock.now()),
      ),
    );
    final record = await _requireRecord(id);
    await _log(id, ActivityEvent.restored);
    final template = await findTemplateById(record.templateId);
    if (template != null && !template.isDeleted) {
      await _syncReminder(record, templateName: template.name);
    }
  }

  @override
  Stream<Map<String, int>> watchRecordCounts() {
    final templateId = _db.customRecords.templateId;
    final count = countAll();
    final query = _db.selectOnly(_db.customRecords).join([
      innerJoin(
        _db.recordTemplates,
        _db.recordTemplates.id.equalsExp(templateId),
      ),
    ])
      ..addColumns([templateId, count])
      ..where(
        _db.customRecords.deletedAt.isNull() &
            _db.recordTemplates.deletedAt.isNull(),
      )
      ..groupBy([templateId]);
    return query.watch().map(
          (rows) => <String, int>{
            for (final row in rows)
              ?row.read(templateId): row.read(count) ?? 0,
          },
        );
  }

  @override
  Stream<List<CustomRecord>> watchRenewingBetween(DateTime from, DateTime to) {
    final query = _liveRecords()
      ..where(
        _db.customRecords.renewalDate.isNotNull() &
            _db.customRecords.renewalDate.isBiggerOrEqualValue(from) &
            _db.customRecords.renewalDate.isSmallerThanValue(to),
      )
      ..orderBy([OrderingTerm.asc(_db.customRecords.renewalDate)]);
    return query.watch().map(_readRecords);
  }

  @override
  Stream<List<CustomRecord>> watchRenewalsNeedingAttention({
    required DateTime today,
  }) {
    final midnight = DateTime(today.year, today.month, today.day);
    final window = DateTime(
      today.year,
      today.month,
      today.day + defaultRecordReminderDays,
    );
    final query = _liveRecords()
      ..where(
        _db.customRecords.renewalDate.isNotNull() &
            _db.customRecords.renewalDate.isSmallerOrEqualValue(window),
      )
      ..orderBy([OrderingTerm.asc(_db.customRecords.renewalDate)]);
    return query.watch().map(_readRecords).map(
          (records) => records
              .where(
                (record) => recordNeedsAttention(
                  recordRenewalStatus(record, midnight),
                ),
              )
              .toList(),
        );
  }

  /// Records joined to their template, with both soft-delete flags applied.
  JoinedSelectStatement<HasResultSet, dynamic> _liveRecords() =>
      _db.select(_db.customRecords).join([
        innerJoin(
          _db.recordTemplates,
          _db.recordTemplates.id.equalsExp(_db.customRecords.templateId),
        ),
      ])
        ..where(
          _db.customRecords.deletedAt.isNull() &
              _db.recordTemplates.deletedAt.isNull(),
        );

  List<CustomRecord> _readRecords(List<TypedResult> rows) =>
      rows.map((row) => _toRecord(row.readTable(_db.customRecords))).toList();

  /// Every record of a template, deleted or not, ignoring the template's own
  /// state — the two reminder loops need exactly this.
  Future<List<CustomRecord>> _recordsOf(String templateId) async {
    final rows = await (_db.select(_db.customRecords)
          ..where((r) => r.templateId.equals(templateId) & r.deletedAt.isNull()))
        .get();
    return rows.map(_toRecord).toList();
  }

  Future<RecordTemplate> _requireTemplate(String id) async {
    final template = await findTemplateById(id);
    if (template == null) throw StateError('No record template with id $id');
    return template;
  }

  Future<CustomRecord> _requireRecord(String id) async {
    final record = await findRecordById(id);
    if (record == null) throw StateError('No custom record with id $id');
    return record;
  }

  Future<void> _log(String recordId, ActivityEvent event, {String? detail}) async {
    await _db.into(_db.activityEntries).insert(
          ActivityRow(
            id: _uuid.v4(),
            ownerType: customRecordOwnerType,
            ownerId: recordId,
            event: event,
            detail: detail,
            at: _clock.now(),
          ),
        );
  }

  Future<void> _syncReminder(
    CustomRecord record, {
    required String templateName,
  }) async {
    final reminder = reminderForRecord(
      record,
      now: _clock.now(),
      templateName: templateName,
    );
    if (reminder == null) {
      await _scheduler.cancel(ReminderKind.customRecord, record.id);
    } else {
      await _scheduler.schedule(reminder);
    }
  }

  RecordTemplate _toTemplate(RecordTemplateRow row) => RecordTemplate(
        id: row.id,
        name: row.name,
        iconKey: row.iconKey,
        fields: decodeRecordFields(row.fields),
        spaceId: row.spaceId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
      );

  RecordTemplatesCompanion _toTemplateRow(RecordTemplate template) =>
      RecordTemplatesCompanion.insert(
        id: template.id,
        name: template.name,
        iconKey: template.iconKey,
        fields: Value(encodeRecordFields(template.fields)),
        spaceId: Value(template.spaceId),
        createdAt: template.createdAt,
        updatedAt: template.updatedAt,
        deletedAt: Value(template.deletedAt),
      );

  CustomRecord _toRecord(CustomRecordRow row) => CustomRecord(
        id: row.id,
        templateId: row.templateId,
        title: row.title,
        values: decodeRecordValues(row.values),
        statusLabel: row.statusLabel,
        renewalDate: row.renewalDate,
        documentId: row.documentId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
      );

  CustomRecordsCompanion _toRecordRow(CustomRecord record) =>
      CustomRecordsCompanion.insert(
        id: record.id,
        templateId: record.templateId,
        title: record.title,
        values: Value(encodeRecordValues(record.values)),
        statusLabel: Value(record.statusLabel),
        renewalDate: Value(record.renewalDate),
        documentId: Value(record.documentId),
        createdAt: record.createdAt,
        updatedAt: record.updatedAt,
        deletedAt: Value(record.deletedAt),
      );
}

@Riverpod(keepAlive: true)
RecordRepository recordRepository(Ref ref) => DriftRecordRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(clockProvider),
      ref.watch(reminderSchedulerProvider),
    );
