import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/models/priority.dart';
import 'package:kosha/core/services/recurrence/recurrence.dart';
import 'package:kosha/features/tasks/domain/entities/activity_entry.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';
import 'package:kosha/features/tasks/domain/task_repository.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../../helpers/fake_reminder_scheduler.dart';
import '../../helpers/test_app.dart';

void main() {
  final now = DateTime(2026, 9, 4, 9, 41);
  final today = DateTime(2026, 9, 4);

  late AppDatabase db;
  late TaskRepository repository;
  late RecordingReminderScheduler scheduler;

  setUp(() {
    db = testDatabase();
    scheduler = RecordingReminderScheduler();
    repository = testRepository(db, now: now, scheduler: scheduler);
  });

  tearDown(() => db.close());

  Future<Task> add(
    String title, {
    DateTime? due,
    int? minutes,
    bool done = false,
  }) async {
    final task = await repository.create(
      NewTask(title: title, dueDate: due, dueMinutes: minutes),
    );
    if (done) await repository.setDone(task.id, done: true);
    return task;
  }

  Future<List<String>> titlesIn(TaskBucket bucket) async {
    final tasks = await repository.watchBucket(bucket, today: today).first;
    return [for (final task in tasks) task.title];
  }

  group('create', () {
    test('assigns an id and timestamps from the clock', () async {
      final task = await repository.create(const NewTask(title: 'Call bank'));
      expect(task.id, isNotEmpty);
      expect(task.createdAt, now);
      expect(task.updatedAt, now);
      expect(task.done, isFalse);
      expect(task.priority, Priority.none);
      expect(await repository.findById(task.id), task);
    });

    test('trims the title and strips the time from the due date', () async {
      final task = await repository.create(
        const NewTask(title: '  Buy groceries  ').copyWithDue(
          DateTime(2026, 9, 4, 18, 30),
        ),
      );
      expect(task.title, 'Buy groceries');
      expect(task.dueDate, DateTime(2026, 9, 4));
    });
  });

  group('watchBucket', () {
    setUp(() async {
      await add('Buy groceries', due: today, minutes: 18 * 60);
      await add('Exercise', due: today, minutes: 7 * 60, done: true);
      await add('Submit rent receipt', due: DateTime(2026, 9, 1));
      await add('Review documents', due: DateTime(2026, 9, 12));
      await add('File ITR acknowledgement');
    });

    test('splits open tasks across the tabs', () async {
      expect(await titlesIn(TaskBucket.today), ['Buy groceries']);
      expect(await titlesIn(TaskBucket.overdue), ['Submit rent receipt']);
      expect(await titlesIn(TaskBucket.upcoming), ['Review documents']);
      expect(await titlesIn(TaskBucket.inbox), ['File ITR acknowledgement']);
    });

    test('the Today tab hides completed tasks; Completed collects them',
        () async {
      expect(await titlesIn(TaskBucket.today), isNot(contains('Exercise')));
      expect(await titlesIn(TaskBucket.completed), ['Exercise']);
    });

    test('untimed tasks sort after timed ones on the same day', () async {
      await add('Anytime errand', due: today);
      final tasks = await repository
          .watchBucket(TaskBucket.today, today: today)
          .first;
      expect(
        [for (final task in tasks) task.title],
        ['Buy groceries', 'Anytime errand'],
      );
    });

    test('emits again when a task changes', () async {
      final stream = repository.watchBucket(TaskBucket.today, today: today);
      expect(await stream.first, hasLength(1));
      await add('Call bank', due: today, minutes: 11 * 60 + 30);
      expect(await stream.first, hasLength(2));
    });
  });

  group('watchDueOn', () {
    test('includes completed tasks and orders them by time', () async {
      await add('Buy groceries', due: today, minutes: 18 * 60);
      await add('Exercise', due: today, minutes: 7 * 60, done: true);
      await add('Review documents', due: DateTime(2026, 9, 12));

      final tasks = await repository.watchDueOn(today).first;
      expect(
        [for (final task in tasks) task.title],
        ['Exercise', 'Buy groceries'],
      );
    });

    test('ignores the time of day in the requested date', () async {
      await add('Buy groceries', due: today);
      final tasks =
          await repository.watchDueOn(DateTime(2026, 9, 4, 23, 59)).first;
      expect(tasks, hasLength(1));
    });
  });

  group('setDone', () {
    test('stamps completedAt and clears it when undone', () async {
      final task = await add('Exercise', due: today);

      await repository.setDone(task.id, done: true);
      final done = await repository.findById(task.id);
      expect(done!.done, isTrue);
      expect(done.completedAt, now);

      await repository.setDone(task.id, done: false);
      final reopened = await repository.findById(task.id);
      expect(reopened!.done, isFalse);
      expect(reopened.completedAt, isNull);
    });
  });

  group('delete', () {
    test('softDelete hides the task and restore brings it back', () async {
      final task = await add('Compare broadband plans');
      expect(await titlesIn(TaskBucket.inbox), ['Compare broadband plans']);

      await repository.softDelete(task.id);
      expect(await titlesIn(TaskBucket.inbox), isEmpty);
      expect(await repository.findById(task.id), isNull);

      await repository.restore(task.id);
      expect(await titlesIn(TaskBucket.inbox), ['Compare broadband plans']);
    });

    test('purge removes the row for good', () async {
      final task = await add('Typo task');
      await repository.purge(task.id);
      await repository.restore(task.id);
      expect(await repository.findById(task.id), isNull);
      expect(await db.select(db.tasks).get(), isEmpty);
    });
  });

  group('save', () {
    test('writes the edited task and refreshes updatedAt', () async {
      final task = await add('Call bank');
      final later = DateTime(2026, 9, 4, 12);
      final editor = testRepository(db, now: later);

      await editor.save(
        task.copyWith(title: 'Call the bank', priority: Priority.medium),
      );

      final saved = await repository.findById(task.id);
      expect(saved!.title, 'Call the bank');
      expect(saved.priority, Priority.medium);
      expect(saved.updatedAt, later);
      expect(saved.createdAt, now);
    });
  });

  group('completing a repeating task', () {
    test('creates the next occurrence and links it to the series', () async {
      final task = await repository.create(
        NewTask(
          title: 'Exercise',
          dueDate: today,
          dueMinutes: 7 * 60,
          recurrenceRule: Recurrence.ruleFor(RecurrencePreset.daily),
        ),
      );

      final result = await repository.setDone(task.id, done: true);

      expect(result.task.done, isTrue);
      final next = result.nextOccurrence;
      expect(next, isNotNull);
      expect(next!.title, 'Exercise');
      expect(next.done, isFalse);
      expect(next.dueDate, DateTime(2026, 9, 5));
      expect(next.dueMinutes, 7 * 60);
      expect(next.parentTaskId, task.id);
      expect(await titlesIn(TaskBucket.upcoming), ['Exercise']);
    });

    test('a monthly task on the last day lands on the next last day', () async {
      final endOfJanuary = DateTime(2027, 1, 31);
      final task = await repository.create(
        NewTask(
          title: 'Submit rent receipt',
          dueDate: endOfJanuary,
          recurrenceRule: Recurrence.ruleFor(
            RecurrencePreset.monthly,
            start: endOfJanuary,
          ),
        ),
      );

      final result = await repository.setDone(task.id, done: true);

      expect(result.nextOccurrence!.dueDate, DateTime(2027, 2, 28));
    });

    test('a one-off task creates nothing', () async {
      final task = await add('Call bank', due: today);
      final result = await repository.setDone(task.id, done: true);
      expect(result.nextOccurrence, isNull);
    });

    test('reopening never creates an occurrence', () async {
      final task = await repository.create(
        NewTask(
          title: 'Exercise',
          dueDate: today,
          recurrenceRule: 'FREQ=DAILY',
        ),
      );
      await repository.setDone(task.id, done: true);
      final reopened = await repository.setDone(task.id, done: false);
      expect(reopened.nextOccurrence, isNull);
    });
  });

  group('reschedule', () {
    test('moves the due date and records why', () async {
      final task = await add('Book dentist appointment', due: today);

      await repository.reschedule(
        task.id,
        dueDate: DateTime(2026, 9, 11),
        dueMinutes: 10 * 60,
      );

      final moved = await repository.findById(task.id);
      expect(moved!.dueDate, DateTime(2026, 9, 11));
      expect(moved.dueMinutes, 10 * 60);

      final history = await repository.watchActivity(task.id).first;
      expect(history.first.event, ActivityEvent.rescheduled);
      expect(history.first.detail, 'to 11 Sep');
    });

    test('clearing the date moves the task to the inbox', () async {
      final task = await add('Compare broadband plans', due: today);
      await repository.reschedule(task.id, dueDate: null);
      expect(await titlesIn(TaskBucket.inbox), ['Compare broadband plans']);
    });
  });

  group('duplicate', () {
    test('copies the task as open and detached from its series', () async {
      final original = await repository.create(
        NewTask(
          title: 'Pay electricity bill',
          dueDate: today,
          priority: Priority.high,
          recurrenceRule: 'FREQ=MONTHLY;BYMONTHDAY=4',
        ),
      );
      await repository.setDone(original.id, done: true);

      final copy = await repository.duplicate(original.id);

      expect(copy.title, 'Pay electricity bill (copy)');
      expect(copy.id, isNot(original.id));
      expect(copy.done, isFalse);
      expect(copy.priority, Priority.high);
      expect(copy.parentTaskId, isNull);
    });
  });

  group('activity history', () {
    test('records the life of a task, newest first', () async {
      final task = await add('Call bank', due: today);
      await repository.setDone(task.id, done: true);
      await repository.setDone(task.id, done: false);
      await repository.softDelete(task.id);
      await repository.restore(task.id);

      final history = await repository.watchActivity(task.id).first;
      expect(
        [for (final entry in history) entry.event],
        [
          ActivityEvent.restored,
          ActivityEvent.deleted,
          ActivityEvent.reopened,
          ActivityEvent.completed,
          ActivityEvent.created,
        ],
      );
    });

    test('purging a task takes its history with it', () async {
      final task = await add('Typo task');
      await repository.purge(task.id);
      expect(await repository.watchActivity(task.id).first, isEmpty);
    });
  });

  group('reminders', () {
    test('a task with a lead time schedules one, offset from the due time',
        () async {
      final task = await repository.create(
        NewTask(
          title: 'Pay electricity bill',
          dueDate: DateTime(2026, 9, 10),
          dueMinutes: 9 * 60,
          reminderOffsetMinutes: 24 * 60,
        ),
      );

      final reminder = scheduler.latestFor(task.id);
      expect(reminder, isNotNull);
      expect(reminder!.fireAt, DateTime(2026, 9, 9, 9));
      expect(reminder.title, 'Pay electricity bill');
      expect(reminder.route, '/tasks/${task.id}');
    });

    test('a task without a lead time schedules nothing', () async {
      final task = await add('Call bank', due: today);
      expect(scheduler.latestFor(task.id), isNull);
      expect(scheduler.cancelled, contains(task.id));
    });

    test('completing and deleting both cancel the reminder', () async {
      final task = await repository.create(
        NewTask(
          title: 'Pay electricity bill',
          dueDate: DateTime(2026, 9, 10),
          reminderOffsetMinutes: 0,
        ),
      );
      scheduler.clear();

      await repository.setDone(task.id, done: true);
      expect(scheduler.cancelled, contains(task.id));

      scheduler.clear();
      await repository.softDelete(task.id);
      expect(scheduler.cancelled, contains(task.id));
    });

    test('resyncReminders re-states only the open, dated, reminded tasks',
        () async {
      final wanted = await repository.create(
        NewTask(
          title: 'Pay electricity bill',
          dueDate: DateTime(2026, 9, 10),
          dueMinutes: 9 * 60,
          reminderOffsetMinutes: 24 * 60,
        ),
      );
      final finished = await repository.create(
        NewTask(
          title: 'Renew insurance',
          dueDate: DateTime(2026, 9, 12),
          reminderOffsetMinutes: 0,
        ),
      );
      await repository.setDone(finished.id, done: true);
      final undated = await repository.create(
        const NewTask(title: 'Read the manual', reminderOffsetMinutes: 0),
      );
      final unreminded = await add('Call bank', due: DateTime(2026, 9, 11));
      scheduler.clear();

      await repository.resyncReminders();

      expect(
        scheduler.scheduled.map((r) => r.ownerId),
        [wanted.id],
        reason: 'only the task that still wants a reminder is re-stated',
      );
      expect(scheduler.scheduled.single.fireAt, DateTime(2026, 9, 9, 9));
      expect(scheduler.cancelled, isNot(contains(finished.id)));
      expect(scheduler.cancelled, isNot(contains(undated.id)));
      expect(scheduler.cancelled, isNot(contains(unreminded.id)));
    });
  });

  group('migration', () {
    test('a v1 database gains the tasks table and keeps its settings',
        () async {
      final dir = Directory.systemTemp.createTempSync('kosha_migration');
      addTearDown(() => dir.deleteSync(recursive: true));
      final file = File(p.join(dir.path, 'kosha.sqlite'));

      final legacy = sqlite3.open(file.path);
      legacy.execute(
        'CREATE TABLE settings (key TEXT NOT NULL, value TEXT NOT NULL, '
        'updated_at INTEGER NOT NULL, PRIMARY KEY (key));',
      );
      legacy.execute(
        'INSERT INTO settings (key, value, updated_at) '
        """VALUES ('theme_mode', '"dark"', 0);""",
      );
      legacy.execute('PRAGMA user_version = 1;');
      legacy.close();

      final upgraded = AppDatabase.withExecutor(NativeDatabase(file));
      addTearDown(upgraded.close);
      final tasks = testRepository(upgraded, now: now);

      await tasks.create(const NewTask(title: 'Survives the upgrade'));

      expect(
        (await upgraded.select(upgraded.tasks).get()).single.title,
        'Survives the upgrade',
      );
      final setting = await (upgraded.select(upgraded.settings)
            ..where((s) => s.key.equals('theme_mode')))
          .getSingle();
      expect(setting.value, '"dark"');
    });
  });

  group('Profile month counts', () {
    test('countCompleted counts what was completed inside the window', () async {
      final inside = await repository.create(const NewTask(title: 'Inside'));
      await repository.setDone(inside.id, done: true);

      expect(
        await repository.countCompleted(
          from: DateTime(2026, 9),
          to: DateTime(2026, 10),
        ),
        1,
      );
      expect(
        await repository.countCompleted(
          from: DateTime(2026, 8),
          to: DateTime(2026, 9),
        ),
        0,
      );
    });

    test('a deleted task stops counting as completed', () async {
      final task = await repository.create(const NewTask(title: 'Thrown away'));
      await repository.setDone(task.id, done: true);
      await repository.softDelete(task.id);

      // Regression: this query was the only one in the repository that did not
      // filter soft-deleted rows, so a task you deleted kept padding Profile's
      // "completed this month" figure.
      expect(
        await repository.countCompleted(
          from: DateTime(2026, 9),
          to: DateTime(2026, 10),
        ),
        0,
      );

      // …and restoring it brings the count back, the way undo should.
      await repository.restore(task.id);
      expect(
        await repository.countCompleted(
          from: DateTime(2026, 9),
          to: DateTime(2026, 10),
        ),
        1,
      );
    });

    test('countCreated ignores deleted tasks too', () async {
      final kept = await repository.create(const NewTask(title: 'Kept'));
      final gone = await repository.create(const NewTask(title: 'Gone'));
      await repository.softDelete(gone.id);

      expect(
        await repository.countCreated(
          from: DateTime(2026, 9),
          to: DateTime(2026, 10),
        ),
        1,
      );
      expect(kept.id, isNotEmpty);
    });
  });
}

extension on NewTask {
  /// Small helper so a const draft can be given a due date in one line.
  NewTask copyWithDue(DateTime due) => NewTask(title: title, dueDate: due);
}
