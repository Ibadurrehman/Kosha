import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/app_database.dart';
import '../../../core/services/notifications/reminder_scheduler.dart';
import '../../../core/services/notifications/scheduled_reminder.dart';
import '../../../core/utils/clock.dart';
import '../../tasks/domain/entities/activity_entry.dart';
import '../domain/document_reminder.dart';
import '../domain/document_repository.dart';
import '../domain/entities/attachment.dart';
import '../domain/entities/document.dart';

part 'document_repository_impl.g.dart';

/// SQLite-backed documents.
///
/// Every write goes through here so the two side effects stay together: the
/// row change and the reminder the operating system holds. Files are not this
/// class's business — [FileService] owns the bytes, and this records where
/// they went. The split matters on replace: the new file is written first, the
/// row is swapped second, and only then does the caller delete the old bytes,
/// so a crash anywhere leaves a document with a readable file rather than a
/// path pointing at nothing.
class DriftDocumentRepository implements DocumentRepository {
  DriftDocumentRepository(this._db, this._clock, this._scheduler);

  static const Uuid _uuid = Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final ReminderScheduler _scheduler;

  @override
  Stream<List<Document>> watchAll({DocumentCategory? category}) {
    final query = _db.select(_db.documents)
      ..where(
        (d) => category == null
            ? d.archivedAt.isNull()
            : d.archivedAt.isNull() & d.category.equalsValue(category),
      )
      ..orderBy([(d) => OrderingTerm.desc(d.createdAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<List<Document>> watchArchived() {
    final query = _db.select(_db.documents)
      ..where((d) => d.archivedAt.isNotNull())
      ..orderBy([(d) => OrderingTerm.desc(d.archivedAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<Document?> watchById(String id) {
    final query = _db.select(_db.documents)..where((d) => d.id.equals(id));
    return query
        .watchSingleOrNull()
        .map((row) => row == null ? null : _toDomain(row));
  }

  @override
  Future<Document?> findById(String id) async {
    final row = await (_db.select(_db.documents)..where((d) => d.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Stream<List<Document>> watchExpiringBetween(DateTime from, DateTime to) {
    final query = _db.select(_db.documents)
      ..where(
        (d) =>
            d.archivedAt.isNull() &
            d.expiresOn.isNotNull() &
            d.expiresOn.isBiggerOrEqualValue(from) &
            d.expiresOn.isSmallerThanValue(to),
      )
      ..orderBy([(d) => OrderingTerm.asc(d.expiresOn)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<List<Document>> watchNeedingAttention({required DateTime today}) {
    // Every document with an expiry is read and then filtered in Dart, because
    // the window is per row: `expires_on <= today + reminder_offset_days` is a
    // comparison between two columns and a parameter, and drift has no typed
    // date arithmetic to express it. The set is small — documents are a
    // handful per user, not a feed — and the alternative is raw SQL with a
    // hand-rolled julianday() expression that the next reader has to verify.
    final query = _db.select(_db.documents)
      ..where((d) => d.archivedAt.isNull() & d.expiresOn.isNotNull())
      ..orderBy([(d) => OrderingTerm.asc(d.expiresOn)]);
    return query.watch().map(
          (rows) => [
            for (final row in rows.map(_toDomain))
              if (needsAttention(documentStatus(row, today))) row,
          ],
        );
  }

  @override
  Stream<List<Document>> watchInSpace(String spaceId, {required int limit}) {
    final query = _db.select(_db.documents)
      ..where((d) => d.archivedAt.isNull() & d.spaceId.equals(spaceId))
      ..orderBy([(d) => OrderingTerm.desc(d.createdAt)])
      ..limit(limit);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<List<Document>> watchRecent({required int limit}) {
    final query = _db.select(_db.documents)
      ..where((d) => d.archivedAt.isNull())
      ..orderBy([(d) => OrderingTerm.desc(d.updatedAt)])
      ..limit(limit);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<Document> create(NewDocument draft) async {
    final now = _clock.now();
    final document = Document(
      id: _uuid.v4(),
      name: draft.name,
      category: draft.category,
      number: draft.number,
      issuedOn: draft.issuedOn,
      expiresOn: draft.expiresOn,
      reminderOffsetDays: draft.reminderOffsetDays,
      notes: draft.notes,
      spaceId: draft.spaceId,
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.documents).insert(_toRow(document));
    await _log(document.id, ActivityEvent.created);
    await _syncReminder(document);
    return document;
  }

  @override
  Future<Document> edit(
    String id, {
    String? name,
    DocumentCategory? category,
    String? number,
    bool clearNumber = false,
    DateTime? issuedOn,
    DateTime? expiresOn,
    bool clearExpiry = false,
    int? reminderOffsetDays,
    String? notes,
    String? spaceId,
  }) async {
    final existing = await _require(id);
    await (_db.update(_db.documents)..where((d) => d.id.equals(id))).write(
      DocumentsCompanion(
        name: name == null ? const Value.absent() : Value(name),
        category: category == null ? const Value.absent() : Value(category),
        number: clearNumber
            ? const Value(null)
            : (number == null ? const Value.absent() : Value(number)),
        issuedOn: issuedOn == null ? const Value.absent() : Value(issuedOn),
        expiresOn: clearExpiry
            ? const Value(null)
            : (expiresOn == null ? const Value.absent() : Value(expiresOn)),
        reminderOffsetDays: reminderOffsetDays == null
            ? const Value.absent()
            : Value(reminderOffsetDays),
        notes: notes == null ? const Value.absent() : Value(notes),
        spaceId: spaceId == null ? const Value.absent() : Value(spaceId),
        updatedAt: Value(_clock.now()),
      ),
    );

    final updated = await _require(id);
    await _log(id, ActivityEvent.edited, detail: _editDetail(existing, updated));
    await _syncReminder(updated);
    return updated;
  }

  @override
  Future<void> archive(String id) async {
    final now = _clock.now();
    await (_db.update(_db.documents)..where((d) => d.id.equals(id))).write(
      DocumentsCompanion(archivedAt: Value(now), updatedAt: Value(now)),
    );
    await _log(id, ActivityEvent.deleted, detail: 'Archived');
    // An archived document reminds about nothing: it is out of the user's
    // way, and a notification about it would drag them back to something they
    // deliberately put down.
    await _scheduler.cancel(ReminderKind.document, id);
  }

  @override
  Future<void> restore(String id) async {
    await (_db.update(_db.documents)..where((d) => d.id.equals(id))).write(
      DocumentsCompanion(
        archivedAt: const Value(null),
        updatedAt: Value(_clock.now()),
      ),
    );
    await _log(id, ActivityEvent.restored);
    await _syncReminder(await _require(id));
  }

  @override
  Stream<List<Attachment>> watchAttachments(String documentId) =>
      _attachmentQuery(documentId)
          .watch()
          .map((rows) => rows.map(_toAttachment).toList());

  @override
  Future<List<Attachment>> listAttachments(String documentId) async {
    final rows = await _attachmentQuery(documentId).get();
    return rows.map(_toAttachment).toList();
  }

  @override
  Future<Attachment> addAttachment(
    String documentId,
    Attachment attachment,
  ) async {
    await _db.into(_db.attachments).insert(_toAttachmentRow(attachment));
    await _touch(documentId);
    await _log(
      documentId,
      ActivityEvent.edited,
      detail: 'Attached ${attachment.fileName}',
    );
    return attachment;
  }

  @override
  Future<Attachment?> replaceAttachment(
    String documentId,
    Attachment replacement,
  ) async {
    final existing = await listAttachments(documentId);
    final previous = existing.isEmpty ? null : existing.last;

    await _db.transaction(() async {
      if (previous != null) {
        await (_db.delete(_db.attachments)
              ..where((a) => a.id.equals(previous.id)))
            .go();
      }
      await _db.into(_db.attachments).insert(_toAttachmentRow(replacement));
    });
    await _touch(documentId);
    // Section 6.8: replacing a file keeps history. The row is gone, so the
    // name it had is the only record that the old file ever existed.
    await _log(
      documentId,
      ActivityEvent.edited,
      detail: previous == null
          ? 'Attached ${replacement.fileName}'
          : 'Replaced ${previous.fileName} with ${replacement.fileName}',
    );
    return previous;
  }

  @override
  Stream<Map<DocumentCategory, int>> watchCategoryCounts() {
    final count = countAll();
    final query = _db.selectOnly(_db.documents)
      ..addColumns([_db.documents.category, count])
      ..where(_db.documents.archivedAt.isNull())
      ..groupBy([_db.documents.category]);
    return query.watch().map(
          (rows) => {
            for (final row in rows)
              _db.documents.category.converter.fromSql(
                row.read<int>(_db.documents.category)!,
              ): row.read(count) ?? 0,
          },
        );
  }

  SimpleSelectStatement<$AttachmentsTable, AttachmentRow> _attachmentQuery(
    String documentId,
  ) =>
      _db.select(_db.attachments)
        ..where(
          (a) =>
              a.ownerType.equals(documentOwnerType) &
              a.ownerId.equals(documentId),
        )
        ..orderBy([(a) => OrderingTerm.asc(a.createdAt)]);

  /// What the activity line says an edit changed. Only the fields a user would
  /// recognise are named — a reminder-offset change reads as the new lead
  /// time, not as a diff of two integers.
  String? _editDetail(Document before, Document after) {
    final changes = <String>[
      if (before.name != after.name) 'renamed',
      if (before.category != after.category) 'moved to ${after.category.label}',
      if (before.expiresOn != after.expiresOn)
        after.expiresOn == null ? 'expiry removed' : 'expiry changed',
      if (before.reminderOffsetDays != after.reminderOffsetDays)
        'reminds ${after.reminderOffsetDays} days ahead',
    ];
    return changes.isEmpty ? null : changes.join(', ');
  }

  Future<void> _touch(String documentId) async {
    await (_db.update(_db.documents)..where((d) => d.id.equals(documentId)))
        .write(DocumentsCompanion(updatedAt: Value(_clock.now())));
  }

  Future<Document> _require(String id) async {
    final document = await findById(id);
    if (document == null) throw StateError('No document with id $id');
    return document;
  }

  Future<void> _log(
    String documentId,
    ActivityEvent event, {
    String? detail,
  }) async {
    await _db.into(_db.activityEntries).insert(
          ActivityRow(
            id: _uuid.v4(),
            ownerType: documentOwnerType,
            ownerId: documentId,
            event: event,
            detail: detail,
            at: _clock.now(),
          ),
        );
  }

  Future<void> _syncReminder(Document document) async {
    final reminder = reminderForDocument(document, now: _clock.now());
    if (reminder == null) {
      await _scheduler.cancel(ReminderKind.document, document.id);
    } else {
      await _scheduler.schedule(reminder);
    }
  }

  Document _toDomain(DocumentRow row) => Document(
        id: row.id,
        name: row.name,
        category: row.category,
        number: row.number,
        issuedOn: row.issuedOn,
        expiresOn: row.expiresOn,
        reminderOffsetDays: row.reminderOffsetDays,
        notes: row.notes,
        spaceId: row.spaceId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        archivedAt: row.archivedAt,
      );

  DocumentsCompanion _toRow(Document document) => DocumentsCompanion.insert(
        id: document.id,
        name: document.name,
        category: document.category,
        number: Value(document.number),
        issuedOn: Value(document.issuedOn),
        expiresOn: Value(document.expiresOn),
        reminderOffsetDays: Value(document.reminderOffsetDays),
        notes: Value(document.notes),
        spaceId: Value(document.spaceId),
        createdAt: document.createdAt,
        updatedAt: document.updatedAt,
        archivedAt: Value(document.archivedAt),
      );

  Attachment _toAttachment(AttachmentRow row) => Attachment(
        id: row.id,
        ownerType: row.ownerType,
        ownerId: row.ownerId,
        fileName: row.fileName,
        mime: row.mime,
        sizeBytes: row.sizeBytes,
        relativePath: row.relativePath,
        sha256: row.sha256,
        createdAt: row.createdAt,
      );

  AttachmentsCompanion _toAttachmentRow(Attachment attachment) =>
      AttachmentsCompanion.insert(
        id: attachment.id,
        ownerType: attachment.ownerType,
        ownerId: attachment.ownerId,
        fileName: attachment.fileName,
        mime: attachment.mime,
        sizeBytes: attachment.sizeBytes,
        relativePath: attachment.relativePath,
        sha256: Value(attachment.sha256),
        createdAt: attachment.createdAt,
      );
}

@Riverpod(keepAlive: true)
DocumentRepository documentRepository(Ref ref) => DriftDocumentRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(clockProvider),
      ref.watch(reminderSchedulerProvider),
    );
