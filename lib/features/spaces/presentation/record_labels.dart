import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/status_pill.dart';
import '../domain/entities/custom_record.dart';
import '../domain/entities/record_template.dart';

/// The shared status vocabulary's value for a record's derived renewal state.
///
/// [RecordRenewalStatus.noRenewal] maps to [KoshaStatus.active] rather than
/// valid: a record that does not renew is something the user is keeping, not
/// something that is currently fine, and [recordStatusLabel] shows their own
/// words for it.
KoshaStatus recordPillStatus(RecordRenewalStatus status) => switch (status) {
      RecordRenewalStatus.overdue => KoshaStatus.overdue,
      RecordRenewalStatus.renewingSoon => KoshaStatus.dueSoon,
      RecordRenewalStatus.valid => KoshaStatus.valid,
      RecordRenewalStatus.noRenewal => KoshaStatus.active,
    };

/// What the pill on a record card actually says.
///
/// A record that renews derives its label from the date; one that does not
/// shows [CustomRecord.statusLabel], or nothing at all when the user never set
/// one — an empty pill would be a shape with no meaning.
String? recordStatusLabel(CustomRecord record, DateTime today) {
  final days = daysUntilRenewal(record, today);
  if (days == null) {
    final label = record.statusLabel?.trim();
    return label == null || label.isEmpty ? null : label;
  }
  return switch (days) {
    0 => 'Renews today',
    1 => 'Renews tomorrow',
    -1 => 'Due yesterday',
    < 0 => 'Due ${-days} days ago',
    _ => 'Renews in $days days',
  };
}

/// How a stored value reads on a card: the raw text for most types, formatted
/// for the two that have a shape of their own.
///
/// Anything that does not parse is shown exactly as it was typed. A value
/// entered as "18,400/yr", or one saved while the field was still a text
/// field, is the user's own words about their own record — rendering it as
/// ₹0 would be worse than leaving it alone.
String formatRecordValue(RecordFieldType type, String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return trimmed;

  return switch (type) {
    RecordFieldType.currency => _formatCurrency(trimmed),
    RecordFieldType.date => _formatDate(trimmed),
    _ => trimmed,
  };
}

String _formatCurrency(String value) {
  final rupees = double.tryParse(value);
  return rupees == null ? value : Money.inr((rupees * 100).round());
}

String _formatDate(String value) {
  final parsed = DateTime.tryParse(value);
  return parsed == null ? value : Dates.dayMonthYear(parsed);
}
