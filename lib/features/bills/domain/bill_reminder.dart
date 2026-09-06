import '../../../core/services/notifications/scheduled_reminder.dart';
import '../../../core/utils/formatters.dart';
import 'entities/bill.dart';

/// Bill reminders fire at 9 am on their day — a bill has a due *date*, never
/// a due time, so there is no per-bill hour to honour.
const int billReminderHour = 9;

/// The moment a bill's reminder is meant to fire, whether or not that moment
/// has passed — null when the bill has nothing to remind about (no date left,
/// so nothing is owed).
///
/// [reminderForBill] filters this to the future, because the OS should only
/// be asked to schedule something ahead of it; the notification inbox's
/// reconciliation wants exactly the past ones. Same split as tasks
/// (`task_reminder.dart`).
DateTime? intendedBillFireAt(Bill bill) {
  final due = bill.nextDue;
  if (due == null) return null;
  return DateTime(
    due.year,
    due.month,
    due.day - bill.reminderOffsetDays,
    billReminderHour,
  );
}

/// The reminder a bill should have scheduled right now, or null when it
/// should have none: nothing owed, or the moment has already passed.
ScheduledReminder? reminderForBill(Bill bill, {required DateTime now}) {
  final fireAt = intendedBillFireAt(bill);
  if (fireAt == null || !fireAt.isAfter(now)) return null;

  return ScheduledReminder(
    kind: ReminderKind.bill,
    ownerId: bill.id,
    title: bill.name,
    body: billReminderBody(bill),
    fireAt: fireAt,
    route: '/home/finance/bills/${bill.id}',
  );
}

/// "₹1,850 · due in 3 days" — the same body whether the reminder is being
/// scheduled ahead of time or reconciled into the inbox after the fact, so
/// the two never say different things about the same moment.
String billReminderBody(Bill bill) {
  final amount = Money.inr(bill.amountMinor);
  final verb = bill.kind == BillKind.subscription ? 'renews' : 'due';
  final days = bill.reminderOffsetDays;
  final when = switch (days) {
    0 => 'today',
    1 => 'tomorrow',
    _ => 'in $days days',
  };
  return '$amount · $verb $when';
}
