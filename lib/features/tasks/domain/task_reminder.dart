import '../../../core/services/notifications/scheduled_reminder.dart';
import 'entities/task.dart';

/// When a task has a due date but no time, its reminder fires at 9 am.
const int defaultReminderMinuteOfDay = 9 * 60;

/// The moment a task's reminder is meant to fire, regardless of whether that
/// moment has already passed — null when the task has no reminder to speak
/// of at all (no offset, no due date, or already done).
///
/// [reminderForTask] filters this to the future, because the OS should only
/// ever be asked to schedule something ahead of it. The notification inbox's
/// reconciliation specifically wants the *past* ones instead — that's what
/// this split is for.
DateTime? intendedFireAt(Task task) {
  final offset = task.reminderOffsetMinutes;
  final due = task.dueDate;
  if (task.done || offset == null || due == null) return null;

  final minutes = task.dueMinutes ?? defaultReminderMinuteOfDay;
  final dueAt = DateTime(
    due.year,
    due.month,
    due.day,
    minutes ~/ 60,
    minutes % 60,
  );
  return dueAt.subtract(Duration(minutes: offset));
}

/// The reminder a task should have scheduled right now, or null when it should
/// have none: no reminder set, no due date, already done, or the moment has
/// already passed.
ScheduledReminder? reminderForTask(Task task, {required DateTime now}) {
  final fireAt = intendedFireAt(task);
  if (fireAt == null || !fireAt.isAfter(now)) return null;

  return ScheduledReminder(
    kind: ReminderKind.task,
    ownerId: task.id,
    title: task.title,
    body: _body(task, task.reminderOffsetMinutes!),
    fireAt: fireAt,
    route: '/tasks/${task.id}',
  );
}

String _body(Task task, int offsetMinutes) {
  final category = task.category;
  final when = offsetMinutes == 0
      ? 'Due now'
      : 'Due in ${_humanOffset(offsetMinutes)}';
  return category == null || category.isEmpty ? when : '$when · $category';
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
