import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_record.freezed.dart';

/// How many days before a renewal a custom record reminds.
///
/// Fixed, not a column. Section 5.1 gives `CustomRecord` a `renewal_date` and
/// no offset beside it, the same shape `Appliance` has — only `Document` and
/// `Bill`, where the user picks a lead time on screen, carry one.
const int defaultRecordReminderDays = 30;

/// Where a record's renewal stands. Never stored — see [recordRenewalStatus].
enum RecordRenewalStatus { valid, renewingSoon, overdue, noRenewal }

/// One row of a user-defined record type: a policy under "My Insurance".
///
/// [values] is keyed by [RecordField.key], never by label, so renaming a field
/// in the template builder keeps every value attached to it.
@freezed
abstract class CustomRecord with _$CustomRecord {
  const factory CustomRecord({
    required String id,
    required String templateId,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(<String, String>{}) Map<String, String> values,

    /// The pill a record with no renewal date shows — "Active", "Lapsed",
    /// whatever the user types. A record that *has* a renewal date derives its
    /// pill instead ([recordRenewalStatus]): a stored label and a date would
    /// otherwise be two sources for one pill, and the stored one goes stale.
    String? statusLabel,

    /// Drives the reminder, and the only thing about a record that can change
    /// on its own.
    DateTime? renewalDate,

    /// A `Document` this record points at, set from a
    /// [RecordFieldType.documentLink] field.
    String? documentId,
    DateTime? deletedAt,
  }) = _CustomRecord;

  const CustomRecord._();

  bool get isDeleted => deletedAt != null;

  bool get renews => renewalDate != null;

  /// The stored value for one template field, or null when the record was
  /// saved before that field existed.
  String? value(String fieldKey) {
    final stored = values[fieldKey];
    return stored == null || stored.isEmpty ? null : stored;
  }
}

/// Fields a caller supplies to create a record; the repository fills in the id
/// and timestamps.
class NewCustomRecord {
  const NewCustomRecord({
    required this.templateId,
    required this.title,
    this.values = const <String, String>{},
    this.statusLabel,
    this.renewalDate,
    this.documentId,
  });

  final String templateId;
  final String title;
  final Map<String, String> values;
  final String? statusLabel;
  final DateTime? renewalDate;
  final String? documentId;
}

/// Section 5.2's derived status, the shape `documentStatus` established.
///
/// A record with no renewal date is [RecordRenewalStatus.noRenewal] rather
/// than valid, for the reason documents give: both are fine states, but only
/// one of them can change, and the pill says different things about them.
///
/// The renewal day itself is not overdue — a policy renewing on the 31st is
/// still current on the 31st.
RecordRenewalStatus recordRenewalStatus(CustomRecord record, DateTime today) {
  final renews = record.renewalDate;
  if (renews == null) return RecordRenewalStatus.noRenewal;
  if (renews.isBefore(DateTime(today.year, today.month, today.day))) {
    return RecordRenewalStatus.overdue;
  }
  final window = DateTime(
    today.year,
    today.month,
    today.day + defaultRecordReminderDays,
  );
  return renews.isAfter(window)
      ? RecordRenewalStatus.valid
      : RecordRenewalStatus.renewingSoon;
}

/// Whether a record belongs in a "needs attention" reading of the renewals.
bool recordNeedsAttention(RecordRenewalStatus status) =>
    status == RecordRenewalStatus.overdue ||
    status == RecordRenewalStatus.renewingSoon;

/// Whole days from [today] until the renewal: negative once it has passed,
/// null when the record never renews.
int? daysUntilRenewal(CustomRecord record, DateTime today) {
  final renews = record.renewalDate;
  if (renews == null) return null;
  return DateTime(renews.year, renews.month, renews.day)
      .difference(DateTime(today.year, today.month, today.day))
      .inDays;
}

/// The record's `values` column: a flat JSON object of field key → value.
///
/// Values are stored as strings whatever the field's type, because the type
/// lives on the template and can be changed there after the value was typed.
/// Keeping the raw text means a number field switched to text still reads
/// back exactly what the user entered, instead of having been coerced at
/// write time into something the new type cannot express.
String encodeRecordValues(Map<String, String> values) => jsonEncode(values);

/// Reads a `values` column back. Non-string scalars — which this app never
/// writes, but a restore or a hand-edit could — are coerced rather than
/// dropped; anything structural (a nested list or object) is skipped, since
/// no field type can render one.
Map<String, String> decodeRecordValues(String source) {
  final Object? decoded;
  try {
    decoded = jsonDecode(source);
  } on FormatException {
    return const <String, String>{};
  }
  if (decoded is! Map) return const <String, String>{};

  final values = <String, String>{};
  decoded.forEach((key, value) {
    if (key is! String) return;
    if (value is String) {
      values[key] = value;
    } else if (value is num || value is bool) {
      values[key] = '$value';
    }
  });
  return values;
}

/// Drops values whose field is no longer in the template, used when a record
/// is written so a template edit does not accumulate dead keys forever.
///
/// Deleting a field in the builder does *not* prune anything by itself — that
/// is ADR 0008's reasoning again: a field removed by mistake and added back
/// keeps its values, because nothing went looking for them in between. The
/// pruning happens only when the user next saves that record, by which point
/// they have seen the editor without the field.
Map<String, String> pruneValues(
  Map<String, String> values,
  Iterable<String> keptKeys,
) {
  final kept = keptKeys.toSet();
  return <String, String>{
    for (final entry in values.entries)
      if (kept.contains(entry.key)) entry.key: entry.value,
  };
}
