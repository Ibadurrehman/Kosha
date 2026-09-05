import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/models/priority.dart';
import 'package:kosha/core/utils/clock.dart';
import 'package:kosha/features/tasks/data/task_repository_impl.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';
import 'package:kosha/features/tasks/domain/task_repository.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  final now = DateTime(2026, 9, 4, 9, 41);
  final today = DateTime(2026, 9, 4);

  late AppDatabase db;
  late TaskRepository repository;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    repository = DriftTaskRepository(db, FixedClock(now));
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
      final editor = DriftTaskRepository(db, FixedClock(later));

      await editor.save(task.copyWith(title: 'Call the bank', priority: Priority.medium));

      final saved = await repository.findById(task.id);
      expect(saved!.title, 'Call the bank');
      expect(saved.priority, Priority.medium);
      expect(saved.updatedAt, later);
      expect(saved.createdAt, now);
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
      final tasks = DriftTaskRepository(upgraded, FixedClock(now));

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
}

extension on NewTask {
  /// Small helper so a const draft can be given a due date in one line.
  NewTask copyWithDue(DateTime due) => NewTask(title: title, dueDate: due);
}
