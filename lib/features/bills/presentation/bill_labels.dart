import '../../../core/services/recurrence/recurrence.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/status_pill.dart';
import '../domain/entities/bill.dart';

/// The status pill's tone for a bill status. Bills reuse the app-wide
/// [KoshaStatus] palette rather than inventing their own colours.
KoshaStatus billPillStatus(BillStatus status) => switch (status) {
      BillStatus.overdue => KoshaStatus.overdue,
      BillStatus.dueSoon => KoshaStatus.dueSoon,
      BillStatus.upcoming => KoshaStatus.upcoming,
      BillStatus.paid => KoshaStatus.paid,
    };

/// "Overdue by 3 days" / "Due in 2 days" / "Renews 15 Sep" / "Paid 28 Aug" —
/// the pill's text, which says more than the bare status wherever a date
/// makes it concrete.
String billBadgeLabel(Bill bill, DateTime today) {
  final status = billStatus(bill, today);
  final due = bill.nextDue;

  switch (status) {
    case BillStatus.paid:
      final paid = bill.lastPaidOn;
      return paid == null ? 'Paid' : 'Paid ${Dates.dayMonth(paid)}';
    case BillStatus.overdue:
      if (due == null) return 'Overdue';
      final days = today.difference(due).inDays;
      return days <= 1 ? 'Overdue since yesterday' : 'Overdue by $days days';
    case BillStatus.dueSoon:
    case BillStatus.upcoming:
      if (due == null) return status == BillStatus.dueSoon ? 'Due Soon' : 'Upcoming';
      final days = due.difference(today).inDays;
      final verb = bill.kind == BillKind.subscription ? 'Renews' : 'Due';
      return switch (days) {
        0 => '$verb today',
        1 => '$verb tomorrow',
        _ when days <= 7 => '$verb in $days days',
        _ => '$verb ${Dates.dayMonth(due)}',
      };
  }
}

/// "Monthly" / "One-off" — how a bill's frequency reads on a chip or a field
/// row. A bill with no rule arrives on no schedule.
String billFrequencyLabel(Bill bill) =>
    bill.repeats ? Recurrence.label(bill.frequencyRule) : 'One-off';

/// The reminder lead time in words, matching how tasks phrase theirs.
String billReminderLabel(int days) => switch (days) {
      0 => 'On the day',
      1 => 'A day before',
      _ => '$days days before',
    };

/// The presets the bill editor offers. "One-off" is the absence of a rule,
/// not a rule of its own, so it maps to [RecurrencePreset.never].
const List<RecurrencePreset> billFrequencyPresets = [
  RecurrencePreset.never,
  RecurrencePreset.monthly,
  RecurrencePreset.quarterly,
  RecurrencePreset.yearly,
];

/// "One-off" reads better than "Never" on a bill, where the alternative to
/// repeating is a single payment rather than a task that never recurs.
String billFrequencyPresetLabel(RecurrencePreset preset) =>
    preset == RecurrencePreset.never ? 'One-off' : preset.label;

/// The lead times the bill editor offers, in days.
const List<int> billReminderChoices = [0, 1, 3, 7, 14];
