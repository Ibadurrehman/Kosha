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

  group('recurrenceLabel', () {
    test('maps the frequencies the app can create', () {
      expect(recurrenceLabel('FREQ=DAILY'), 'Daily');
      expect(recurrenceLabel('FREQ=WEEKLY;BYDAY=MO'), 'Weekly');
      expect(recurrenceLabel('FREQ=MONTHLY'), 'Monthly');
      expect(recurrenceLabel('FREQ=YEARLY'), 'Yearly');
      expect(recurrenceLabel('nonsense'), 'Repeats');
    });
  });
}
