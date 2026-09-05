import '../../../core/utils/formatters.dart';
import '../domain/entities/task.dart';

/// The leading fragment of a task's meta line: a time when the task is due
/// today, otherwise a date, a recurrence, or "No date".
String taskWhenLabel(Task task, DateTime today) {
  final due = task.dueDate;
  final rule = task.recurrenceRule;
  if (due == null) {
    return task.repeats ? recurrenceLabel(rule!) : 'No date';
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
  final rule = task.recurrenceRule;
  if (task.dueDate != null && task.repeats) parts.add(recurrenceLabel(rule!));
  return parts.join(' · ');
}

/// Turns an RFC 5545 rule into a short label. The full editor arrives with the
/// recurrence engine in week 2.
String recurrenceLabel(String rule) {
  final freq = RegExp('FREQ=([A-Z]+)').firstMatch(rule.toUpperCase())?.group(1);
  return switch (freq) {
    'DAILY' => 'Daily',
    'WEEKLY' => 'Weekly',
    'MONTHLY' => 'Monthly',
    'YEARLY' => 'Yearly',
    _ => 'Repeats',
  };
}
