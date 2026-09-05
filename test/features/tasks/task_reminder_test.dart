import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/services/notifications/scheduled_reminder.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';
import 'package:kosha/features/tasks/domain/task_reminder.dart';

void main() {
  final now = DateTime(2026, 9, 4, 9, 41);

  Task task({
    DateTime? due,
    int? minutes,
    int? reminder,
    bool done = false,
    String? category,
  }) =>
      Task(
        id: 'task-1',
        title: 'Pay electricity bill',
        createdAt: now,
        updatedAt: now,
        dueDate: due,
        dueMinutes: minutes,
        reminderOffsetMinutes: reminder,
        done: done,
        category: category,
      );

  group('reminderForTask', () {
    test('fires the lead time before the due time', () {
      final reminder = reminderForTask(
        task(due: DateTime(2026, 9, 10), minutes: 9 * 60, reminder: 24 * 60),
        now: now,
      );
      expect(reminder!.fireAt, DateTime(2026, 9, 9, 9));
      expect(reminder.kind, ReminderKind.task);
      expect(reminder.ownerId, 'task-1');
      expect(reminder.route, '/tasks/task-1');
    });

    test('a task with no time of its own is treated as due at 9 am', () {
      final reminder = reminderForTask(
        task(due: DateTime(2026, 9, 10), reminder: 0),
        now: now,
      );
      expect(reminder!.fireAt, DateTime(2026, 9, 10, 9));
    });

    test('no reminder without a lead time or a date', () {
      expect(
        reminderForTask(task(due: DateTime(2026, 9, 10)), now: now),
        isNull,
      );
      expect(reminderForTask(task(reminder: 0), now: now), isNull);
    });

    test('a completed task never has one', () {
      expect(
        reminderForTask(
          task(due: DateTime(2026, 9, 10), reminder: 0, done: true),
          now: now,
        ),
        isNull,
      );
    });

    test('a moment already past is not scheduled', () {
      expect(
        reminderForTask(
          task(due: DateTime(2026, 9, 4), minutes: 8 * 60, reminder: 0),
          now: now,
        ),
        isNull,
      );
    });

    test('the body names the lead time and the category', () {
      final reminder = reminderForTask(
        task(
          due: DateTime(2026, 9, 10),
          reminder: 24 * 60,
          category: 'Home',
        ),
        now: now,
      );
      expect(reminder!.body, 'Due in a day · Home');
    });
  });

  group('reminderNotificationId', () {
    test('is stable for the same owner and differs between owners', () {
      final first = reminderNotificationId(ReminderKind.task, 'abc');
      expect(reminderNotificationId(ReminderKind.task, 'abc'), first);
      expect(
        reminderNotificationId(ReminderKind.task, 'abd'),
        isNot(first),
      );
    });

    test('the same id under a different kind is a different notification', () {
      expect(
        reminderNotificationId(ReminderKind.bill, 'abc'),
        isNot(reminderNotificationId(ReminderKind.task, 'abc')),
      );
    });

    test('always fits in a positive 31-bit int', () {
      for (final id in ['a', 'a-very-long-uuid-like-string-0123456789', '']) {
        final value = reminderNotificationId(ReminderKind.task, id);
        expect(value, greaterThanOrEqualTo(0));
        expect(value, lessThan(1 << 31));
      }
    });
  });
}
