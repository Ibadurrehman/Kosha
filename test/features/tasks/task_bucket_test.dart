import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';

void main() {
  final now = DateTime(2026, 9, 4, 9, 41);
  final today = DateTime(2026, 9, 4);

  Task task({DateTime? due, int? minutes, bool done = false}) => Task(
        id: 'id',
        title: 'Task',
        createdAt: now,
        updatedAt: now,
        dueDate: due,
        dueMinutes: minutes,
        done: done,
      );

  group('bucketOn', () {
    test('a task with no due date sits in the inbox', () {
      expect(task().bucketOn(today), TaskBucket.inbox);
    });

    test('yesterday is overdue, today is today, tomorrow is upcoming', () {
      expect(
        task(due: DateTime(2026, 9, 3)).bucketOn(today),
        TaskBucket.overdue,
      );
      expect(task(due: DateTime(2026, 9, 4)).bucketOn(today), TaskBucket.today);
      expect(
        task(due: DateTime(2026, 9, 5)).bucketOn(today),
        TaskBucket.upcoming,
      );
    });

    test('completion wins over the date', () {
      expect(
        task(due: DateTime(2026, 9, 1), done: true).bucketOn(today),
        TaskBucket.completed,
      );
      expect(task(done: true).bucketOn(today), TaskBucket.completed);
    });

    test('the time of day never changes the bucket', () {
      final lateToday = task(due: DateTime(2026, 9, 4, 23, 59));
      final earlyToday = task(due: DateTime(2026, 9, 4, 0, 1));
      expect(lateToday.bucketOn(today), TaskBucket.today);
      expect(earlyToday.bucketOn(today), TaskBucket.today);
      expect(lateToday.bucketOn(DateTime(2026, 9, 4, 23, 59)), TaskBucket.today);
    });

    test('the same task moves from Today to Overdue at midnight', () {
      final t = task(due: DateTime(2026, 9, 4), minutes: 9 * 60);
      expect(t.bucketOn(DateTime(2026, 9, 4)), TaskBucket.today);
      expect(t.bucketOn(DateTime(2026, 9, 5)), TaskBucket.overdue);
    });

    test('a month and a year boundary are handled by calendar, not by hours',
        () {
      final newYearsEve = task(due: DateTime(2026, 12, 31));
      expect(newYearsEve.bucketOn(DateTime(2026, 12, 31)), TaskBucket.today);
      expect(newYearsEve.bucketOn(DateTime(2027, 1, 1)), TaskBucket.overdue);
      expect(newYearsEve.bucketOn(DateTime(2026, 11, 30)), TaskBucket.upcoming);
    });
  });

  group('dueAt', () {
    test('is null without a date and midnight without a time', () {
      expect(task().dueAt, isNull);
      expect(task(due: DateTime(2026, 9, 4)).dueAt, DateTime(2026, 9, 4));
    });

    test('combines the date with minutes since midnight', () {
      expect(
        task(due: DateTime(2026, 9, 4), minutes: 18 * 60 + 30).dueAt,
        DateTime(2026, 9, 4, 18, 30),
      );
    });
  });

  group('repeats', () {
    test('is false for null and empty rules', () {
      expect(task().repeats, isFalse);
      expect(task().copyWith(recurrenceRule: '').repeats, isFalse);
      expect(
        task().copyWith(recurrenceRule: 'FREQ=DAILY').repeats,
        isTrue,
      );
    });
  });
}
