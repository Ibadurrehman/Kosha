import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/models/priority.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';
import 'package:kosha/features/tasks/presentation/task_labels.dart';

void main() {
  final now = DateTime(2026, 9, 4, 9, 41);
  final today = DateTime(2026, 9, 4);

  Task task({
    DateTime? due,
    int? minutes,
    Priority priority = Priority.none,
    String? category,
    String? rule,
  }) =>
      Task(
        id: 'id',
        title: 'Task',
        createdAt: now,
        updatedAt: now,
        dueDate: due,
        dueMinutes: minutes,
        priority: priority,
        category: category,
        recurrenceRule: rule,
      );

  group('taskWhenLabel', () {
    test('shows the time for a task due today, or just "Today"', () {
      expect(taskWhenLabel(task(due: today, minutes: 540), today), '9:00 AM');
      expect(taskWhenLabel(task(due: today), today), 'Today');
    });

    test('names tomorrow and dates further out', () {
      expect(taskWhenLabel(task(due: DateTime(2026, 9, 5)), today), 'Tomorrow');
      expect(taskWhenLabel(task(due: DateTime(2026, 9, 12)), today), '12 Sep');
      expect(
        taskWhenLabel(task(due: DateTime(2026, 9, 1)), today),
        '1 Sep',
      );
    });

    test('includes the year only when it differs from today', () {
      expect(
        taskWhenLabel(task(due: DateTime(2027, 3, 31)), today),
        '31 Mar 2027',
      );
    });

    test('falls back to the recurrence, then to "No date"', () {
      expect(taskWhenLabel(task(rule: 'FREQ=DAILY'), today), 'Daily');
      expect(taskWhenLabel(task(), today), 'No date');
    });
  });

  group('taskMetaLine', () {
    test('joins date, category and priority with a middle dot', () {
      final line = taskMetaLine(
        task(
          due: today,
          minutes: 540,
          category: 'Home',
          priority: Priority.high,
        ),
        today,
      );
      expect(line, '9:00 AM · Home · High');
    });

    test('omits an unset priority and an empty category', () {
      expect(taskMetaLine(task(due: today, category: ''), today), 'Today');
    });

    test('appends the repeat when the task also has a date', () {
      expect(
        taskMetaLine(task(due: today, rule: 'FREQ=DAILY'), today),
        'Today · Daily',
      );
    });
  });

  group('reminderLabel', () {
    test('names the lead times the editor offers', () {
      expect(reminderLabel(null), 'None');
      expect(reminderLabel(0), 'At the time');
      expect(reminderLabel(60), '1 hour before');
      expect(reminderLabel(24 * 60), '1 day before');
      expect(reminderLabel(48 * 60), '2 days before');
    });

    test('falls back to hours, days or minutes for other values', () {
      expect(reminderLabel(3 * 60), '3 hours before');
      expect(reminderLabel(3 * 24 * 60), '3 days before');
      expect(reminderLabel(15), '15 minutes before');
    });
  });

  group('taskBadgeLabel', () {
    test('reads the way the prototype badge does', () {
      expect(taskBadgeLabel(task(due: today), today), 'Due today');
      expect(
        taskBadgeLabel(task(due: DateTime(2026, 9, 1)), today),
        'Overdue',
      );
      expect(
        taskBadgeLabel(task(due: DateTime(2026, 9, 12)), today),
        'Due 12 Sep 2026',
      );
      expect(taskBadgeLabel(task(), today), 'No date set');
      expect(taskBadgeLabel(task(rule: 'FREQ=DAILY'), today), 'Daily');
    });

    test('a completed task reads as Completed whatever its date', () {
      final done = task(due: DateTime(2026, 9, 1)).copyWith(done: true);
      expect(taskBadgeLabel(done, today), 'Completed');
    });
  });
}
