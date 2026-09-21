import '../../../core/services/notifications/scheduled_reminder.dart';
import 'entities/document.dart';

/// Document reminders fire at 9 am on their day, the hour bills already use —
/// a document has an expiry *date*, never a time.
const int documentReminderHour = 9;

/// The moment a document's reminder is meant to fire, whether or not that
/// moment has passed — null when there is nothing to remind about.
///
/// [reminderForDocument] filters this to the future, because the OS should
/// only be asked to schedule something ahead of it; the notification inbox's
/// reconciliation wants exactly the past ones. Same split as tasks and bills.
DateTime? intendedDocumentFireAt(Document document) {
  final expires = document.expiresOn;
  if (expires == null || document.isArchived) return null;
  return DateTime(
    expires.year,
    expires.month,
    expires.day - document.reminderOffsetDays,
    documentReminderHour,
  );
}

/// The reminder a document should have scheduled right now, or null when it
/// should have none: no expiry, archived, or the moment has already passed.
ScheduledReminder? reminderForDocument(
  Document document, {
  required DateTime now,
}) {
  final fireAt = intendedDocumentFireAt(document);
  if (fireAt == null || !fireAt.isAfter(now)) return null;

  return ScheduledReminder(
    kind: ReminderKind.document,
    ownerId: document.id,
    title: document.name,
    body: documentReminderBody(document),
    fireAt: fireAt,
    // Documents sit in the Spaces branch, so a tapped reminder lights the
    // Spaces tab. The literal path avoids a dependency from domain code on
    // the router (section 4.2's layering rule), the way bills do it.
    route: '/documents/${document.id}',
  );
}

/// "Expires in 30 days · Identity" — the same body whether the reminder is
/// being scheduled ahead of time or reconciled into the inbox afterwards, so
/// the two never say different things about the same moment.
String documentReminderBody(Document document) {
  final days = document.reminderOffsetDays;
  final when = switch (days) {
    0 => 'Expires today',
    1 => 'Expires tomorrow',
    _ => 'Expires in $days days',
  };
  return '$when · ${document.category.label}';
}
