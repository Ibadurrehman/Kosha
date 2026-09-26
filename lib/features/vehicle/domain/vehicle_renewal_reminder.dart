import '../../../core/services/notifications/scheduled_reminder.dart';
import 'entities/vehicle_renewal.dart';

/// Renewal reminders fire at 9 am on their day, the hour documents and bills
/// already use — a renewal has a due *date*, never a time.
const int vehicleRenewalReminderHour = 9;

/// The moment a renewal's reminder is meant to fire, whether or not that
/// moment has passed.
DateTime intendedVehicleRenewalFireAt(VehicleRenewal renewal) => DateTime(
      renewal.validTill.year,
      renewal.validTill.month,
      renewal.validTill.day - renewal.reminderOffsetDays,
      vehicleRenewalReminderHour,
    );

/// The reminder a renewal should have scheduled right now, or null when the
/// moment has already passed — the same split tasks, bills and documents make
/// between what should be scheduled ahead of time and what reconciliation
/// reads afterwards.
ScheduledReminder? reminderForVehicleRenewal(
  VehicleRenewal renewal, {
  required DateTime now,
}) {
  final fireAt = intendedVehicleRenewalFireAt(renewal);
  if (!fireAt.isAfter(now)) return null;

  return ScheduledReminder(
    kind: ReminderKind.vehicleRenewal,
    ownerId: renewal.id,
    title: '${renewal.kind.label} renewal',
    fireAt: fireAt,
    body: vehicleRenewalReminderBody(renewal),
    // Vehicle sits in the Spaces branch, so a tapped reminder lights the
    // Spaces tab — the same literal-path choice `document_reminder.dart`
    // makes to keep domain code off the router (section 4.2's layering rule).
    route: '/vehicle',
  );
}

/// "Due in 30 days · Insurance" — the same body whether the reminder is being
/// scheduled ahead of time or reconciled into the inbox afterwards.
String vehicleRenewalReminderBody(VehicleRenewal renewal) {
  final days = renewal.reminderOffsetDays;
  final when = switch (days) {
    0 => 'Due today',
    1 => 'Due tomorrow',
    _ => 'Due in $days days',
  };
  return '$when · ${renewal.kind.label}';
}
