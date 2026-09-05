import '../../../core/services/notifications/scheduled_reminder.dart';
import 'entities/event.dart';

/// The moment an event's reminder is meant to fire, regardless of whether
/// that moment has already passed — mirrors `task_reminder.dart`'s
/// `intendedFireAt`, for the same reason: OS scheduling wants the future,
/// notification-inbox reconciliation wants the past.
DateTime? intendedEventFireAt(Event event) {
  final offset = event.reminderOffsetMinutes;
  if (offset == null) return null;
  return event.startAt.subtract(Duration(minutes: offset));
}

/// The reminder an event should have scheduled right now, or null when it
/// should have none: no reminder set, or the moment has already passed.
ScheduledReminder? reminderForEvent(Event event, {required DateTime now}) {
  final fireAt = intendedEventFireAt(event);
  if (fireAt == null || !fireAt.isAfter(now)) return null;

  return ScheduledReminder(
    kind: ReminderKind.event,
    ownerId: event.id,
    title: event.title,
    body: event.allDay ? 'All day' : _startsIn(event, event.reminderOffsetMinutes!),
    fireAt: fireAt,
    route: '/calendar',
  );
}

String _startsIn(Event event, int offsetMinutes) {
  if (offsetMinutes == 0) return 'Starting now';
  return 'Starts in ${_humanOffset(offsetMinutes)}';
}

String _humanOffset(int minutes) {
  if (minutes % (60 * 24) == 0) {
    final days = minutes ~/ (60 * 24);
    return days == 1 ? 'a day' : '$days days';
  }
  if (minutes % 60 == 0) {
    final hours = minutes ~/ 60;
    return hours == 1 ? 'an hour' : '$hours hours';
  }
  return '$minutes minutes';
}
