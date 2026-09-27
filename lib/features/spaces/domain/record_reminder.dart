import '../../../core/services/notifications/scheduled_reminder.dart';
import 'entities/custom_record.dart';

/// Record reminders fire at 9 am on their day — the hour bills, documents and
/// vehicle renewals all use. A renewal is a date, never a time.
const int recordReminderHour = 9;

/// The moment a record's reminder is meant to fire, whether or not that moment
/// has passed — null when there is nothing to remind about.
///
/// [reminderForRecord] filters this to the future, because the OS should only
/// be asked to schedule something ahead of it; the notification inbox's
/// reconciliation wants exactly the past ones. Same split as tasks, bills and
/// documents.
DateTime? intendedRecordFireAt(CustomRecord record) {
  final renews = record.renewalDate;
  if (renews == null || record.isDeleted) return null;
  return DateTime(
    renews.year,
    renews.month,
    renews.day - defaultRecordReminderDays,
    recordReminderHour,
  );
}

/// The reminder a record should have scheduled right now, or null when it
/// should have none: no renewal date, deleted, or the moment has passed.
ScheduledReminder? reminderForRecord(
  CustomRecord record, {
  required DateTime now,
  required String templateName,
}) {
  final fireAt = intendedRecordFireAt(record);
  if (fireAt == null || !fireAt.isAfter(now)) return null;

  return ScheduledReminder(
    kind: ReminderKind.customRecord,
    ownerId: record.id,
    title: record.title,
    body: recordReminderBody(templateName),
    fireAt: fireAt,
    // Custom records sit in the Spaces branch, so a tapped reminder lights the
    // Spaces tab. The literal path keeps domain code off the router, the way
    // documents and bills do it (§4.2).
    route: '/records/${record.templateId}',
  );
}

/// "Renews in 30 days · My Insurance" — the same body whether the reminder is
/// being scheduled ahead of time or reconciled into the inbox afterwards, so
/// the two never say different things about the same moment.
String recordReminderBody(String templateName) =>
    'Renews in $defaultRecordReminderDays days · $templateName';
