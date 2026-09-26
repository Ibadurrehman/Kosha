import 'entities/custom_record.dart';
import 'entities/record_template.dart';

/// Reads and writes custom record types and their rows (section 6.5).
///
/// "Live" throughout means not deleted. Deleting is soft on both tables and
/// deleting a template does **not** touch its records: they stop being
/// readable because every read joins through a live template, and restoring
/// the template brings all of them back in one row write. That is ADR 0008's
/// reasoning applied a second time — the observable behaviour is identical
/// either way, except when the user undoes.
abstract interface class RecordRepository {
  /// Every live template, newest first.
  Stream<List<RecordTemplate>> watchTemplates();

  Stream<RecordTemplate?> watchTemplateById(String id);

  Future<RecordTemplate?> findTemplateById(String id);

  Future<RecordTemplate> createTemplate(NewRecordTemplate draft);

  /// Applies an edit. Every argument is optional; omitting one leaves that
  /// field alone. Passing [fields] replaces the whole list, which is what the
  /// template builder does on Save — add, rename and reorder are all just a
  /// different list.
  ///
  /// Renaming a field keeps its values, because a field's identity is its
  /// `key` and only the label changed. Removing one leaves the values it held
  /// in place until each record is next saved ([pruneValues]).
  Future<RecordTemplate> editTemplate(
    String id, {
    String? name,
    String? iconKey,
    List<RecordField>? fields,
    String? spaceId,
    bool clearSpaceId = false,
  });

  /// Hides the template and cancels the reminders of every record under it.
  /// The records themselves are left alone so [restoreTemplate] is one write.
  Future<void> deleteTemplate(String id);

  /// Brings a template back and re-schedules its records' future reminders.
  Future<void> restoreTemplate(String id);

  /// The live records of one template, newest first. Empty — not an error —
  /// when the template itself has been deleted.
  Stream<List<CustomRecord>> watchRecords(String templateId);

  Stream<CustomRecord?> watchRecordById(String id);

  Future<CustomRecord?> findRecordById(String id);

  Future<CustomRecord> createRecord(NewCustomRecord draft);

  /// Applies an edit and re-syncs the record's reminder.
  ///
  /// [renewalDate], [statusLabel] and [documentId] are all clearable, so each
  /// takes a sentinel rather than letting null mean two things at once — the
  /// shape `DocumentRepository.edit`'s `clearExpiry` set, and the omission
  /// that cost `VehicleRepository.edit` a silent no-op (§12.5.3).
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
  });

  Future<void> deleteRecord(String id);

  Future<void> restoreRecord(String id);

  /// How many live records each live template holds, for the Spaces grid's
  /// Custom records card and the template list's sub-lines.
  Stream<Map<String, int>> watchRecordCounts();

  /// Records renewing inside a window, soonest first — the shape Home's
  /// Upcoming and the Calendar ask documents for.
  Stream<List<CustomRecord>> watchRenewingBetween(DateTime from, DateTime to);

  /// Overdue or renewing-within-[defaultRecordReminderDays] records, most
  /// urgent first.
  ///
  /// Unlike documents this *could* be a single date-range query, because the
  /// lead time is one constant rather than a per-row column. It is written as
  /// a range query for exactly that reason, and the day the lead time becomes
  /// a column is the day it has to move into Dart the way documents did.
  Stream<List<CustomRecord>> watchRenewalsNeedingAttention({
    required DateTime today,
  });
}
