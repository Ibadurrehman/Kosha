import '../../../core/services/notifications/scheduled_reminder.dart';
import 'entities/task.dart';

/// When a task has a due date but no time, its reminder fires at 9 am.
const int defaultReminderMinuteOfDay = 9 * 60;

/// The reminder a task should have scheduled right now, or null when it should
/// have none: no reminder set, no due date, already done, or the moment has
/// already passed.
ScheduledReminder? reminderForTask(Task task, {required DateTime now}) {
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
  final fireAt = dueAt.subtract(Duration(minutes: offset));
  if (!fireAt.isAfter(now)) return null;

  return ScheduledReminder(
    kind: ReminderKind.task,
    ownerId: task.id,
    title: task.title,
    body: _body(task, offset),
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
