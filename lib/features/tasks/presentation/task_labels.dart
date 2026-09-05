import '../../../core/services/recurrence/recurrence.dart';
import '../../../core/utils/formatters.dart';
import '../domain/entities/task.dart';

/// Reminder lead times the editor offers, from "none" to two days before.
const List<int?> reminderOffsetOptions = <int?>[null, 0, 60, 24 * 60, 48 * 60];

/// "1 day before" — how a reminder lead time reads in the UI.
String reminderLabel(int? offsetMinutes) => switch (offsetMinutes) {
      null => 'None',
      0 => 'At the time',
      60 => '1 hour before',
      // Written out: a constant pattern cannot contain arithmetic.
      1440 => '1 day before',
      2880 => '2 days before',
      final int minutes when minutes % (24 * 60) == 0 =>
        '${minutes ~/ (24 * 60)} days before',
      final int minutes when minutes % 60 == 0 =>
        '${minutes ~/ 60} hours before',
      final int minutes => '$minutes minutes before',
    };

/// The leading fragment of a task's meta line: a time when the task is due
/// today, otherwise a date, a recurrence, or "No date".
String taskWhenLabel(Task task, DateTime today) {
  final due = task.dueDate;
  if (due == null) {
    return task.repeats ? Recurrence.label(task.recurrenceRule) : 'No date';
  }
  final date = dateOnly(due);
  final start = dateOnly(today);
  final minutes = task.dueMinutes;
  final time = minutes == null ? null : Dates.minuteOfDay(minutes);
  if (date == start) return time ?? 'Today';
  if (date == DateTime(start.year, start.month, start.day + 1)) {
    return time == null ? 'Tomorrow' : 'Tomorrow, $time';
  }
  final day = date.year == start.year
      ? Dates.dayMonth(date)
      : Dates.dayMonthYear(date);
  return time == null ? day : '$day, $time';
}

/// "9:00 AM · Home · High" — the sub-line under a task title.
String taskMetaLine(Task task, DateTime today) {
  final parts = <String>[taskWhenLabel(task, today)];
  final category = task.category;
  if (category != null && category.isNotEmpty) parts.add(category);
  if (task.priority.isSet) parts.add(task.priority.label);
  if (task.dueDate != null && task.repeats) {
    parts.add(Recurrence.label(task.recurrenceRule));
  }
  return parts.join(' · ');
}

/// The status badge at the top of the task detail screen.
String taskBadgeLabel(Task task, DateTime today) {
  if (task.done) return 'Completed';
  final bucket = task.bucketOn(today);
  if (bucket == TaskBucket.overdue) return 'Overdue';
  if (bucket == TaskBucket.today) return 'Due today';
  final due = task.dueDate;
  if (due != null) return 'Due ${Dates.dayMonthYear(due)}';
  return task.repeats ? Recurrence.label(task.recurrenceRule) : 'No date set';
}
