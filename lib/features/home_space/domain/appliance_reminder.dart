import '../../../core/services/notifications/scheduled_reminder.dart';
import 'entities/appliance.dart';

/// Appliance reminders fire at 9 am on their day, the hour documents, bills
/// and vehicle renewals already use — a warranty has an expiry *date*, never
/// a time.
const int applianceReminderHour = 9;

/// The moment an appliance's reminder is meant to fire, whether or not that
/// moment has passed — null when there is nothing to remind about.
DateTime? intendedApplianceFireAt(Appliance appliance) {
  final till = appliance.warrantyTill;
  if (till == null || appliance.isDeleted) return null;
  return DateTime(
    till.year,
    till.month,
    till.day - defaultApplianceWarrantyReminderDays,
    applianceReminderHour,
  );
}

/// The reminder an appliance should have scheduled right now, or null when it
/// should have none: no warranty date, deleted, or the moment has already
/// passed.
ScheduledReminder? reminderForAppliance(
  Appliance appliance, {
  required DateTime now,
}) {
  final fireAt = intendedApplianceFireAt(appliance);
  if (fireAt == null || !fireAt.isAfter(now)) return null;

  return ScheduledReminder(
    kind: ReminderKind.appliance,
    ownerId: appliance.id,
    title: '${appliance.name} warranty',
    body: applianceReminderBody(appliance),
    fireAt: fireAt,
    // Home management sits in the Spaces branch, so a tapped reminder lights
    // the Spaces tab — the same literal-path choice `document_reminder.dart`
    // and `vehicle_renewal_reminder.dart` make.
    route: '/home-management',
  );
}

/// "Warranty expires in 30 days" — the same body whether the reminder is
/// being scheduled ahead of time or reconciled into the inbox afterwards.
///
/// Always the same lead time: unlike documents, bills and vehicle renewals,
/// Appliance has no per-row `reminderOffsetDays` — see
/// [defaultApplianceWarrantyReminderDays]'s doc comment.
String applianceReminderBody(Appliance appliance) =>
    'Warranty expires in $defaultApplianceWarrantyReminderDays days';
