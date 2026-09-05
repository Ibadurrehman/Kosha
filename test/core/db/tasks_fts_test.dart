import 'dart:io';

import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../../helpers/test_app.dart';

void main() {
  Future<Set<String>> matches(AppDatabase db, String query) async {
    final rows = await db
        .customSelect(
          'SELECT tasks.id AS id FROM tasks_fts '
          'JOIN tasks ON tasks.rowid = tasks_fts.rowid '
          'WHERE tasks_fts MATCH ?',
          variables: [Variable.withString(query)],
        )
        .get();
    return {for (final row in rows) row.read<String>('id')};
  }

  group('a fresh install', () {
    late AppDatabase db;

    setUp(() => db = testDatabase());
    tearDown(() => db.close());

    test('an inserted task is immediately findable by title', () async {
      final repository = testRepository(db);
      final task = await repository.create(
        const NewTask(title: 'Renew passport', category: 'Documents'),
      );
      expect(await matches(db, 'passport'), {task.id});
      expect(await matches(db, 'documents'), {task.id});
    });

    test('a deleted (purged) task drops out of the index', () async {
      final repository = testRepository(db);
      final task = await repository.create(const NewTask(title: 'Renew passport'));
      await repository.purge(task.id);
      expect(await matches(db, 'passport'), isEmpty);
    });

    test('editing the title updates what is findable', () async {
      final repository = testRepository(db);
      final task = await repository.create(const NewTask(title: 'Renew passport'));
      await repository.save(task.copyWith(title: 'Renew driving licence'));

      expect(await matches(db, 'passport'), isEmpty);
      expect(await matches(db, 'licence'), {task.id});
    });

    test('a soft-deleted task is still indexed (it can be undone)', () async {
      final repository = testRepository(db);
      final task = await repository.create(const NewTask(title: 'Renew passport'));
      await repository.softDelete(task.id);
      expect(await matches(db, 'passport'), {task.id});
    });
  });

  test('an upgrade from v7 backfills the index for pre-existing tasks',
      () async {
    final dir = Directory.systemTemp.createTempSync('kosha_migration_fts');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File(p.join(dir.path, 'kosha.sqlite'));

    final legacy = sqlite3.open(file.path);
    legacy.execute('''
      CREATE TABLE tasks (
        id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        due_date INTEGER,
        due_minutes INTEGER,
        priority INTEGER NOT NULL DEFAULT 0,
        done INTEGER NOT NULL DEFAULT 0,
        completed_at INTEGER,
        recurrence_rule TEXT,
        reminder_offset_minutes INTEGER,
        category TEXT,
        space_id TEXT,
        parent_task_id TEXT,
        source INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        deleted_at INTEGER,
        PRIMARY KEY (id)
      );
    ''');
    legacy.execute(
      'INSERT INTO tasks (id, title, description, category, created_at, updated_at) '
      "VALUES ('t1', 'Renew passport', 'Check the expiry date', 'Documents', 0, 0);",
    );
    // Pre-v8: no tasks_fts table exists yet, matching a real install that
    // stopped before this migration shipped.
    legacy.execute('PRAGMA user_version = 7;');
    legacy.close();

    final upgraded = AppDatabase.withExecutor(NativeDatabase(file));
    addTearDown(upgraded.close);

    final results = await upgraded
        .customSelect("SELECT rowid FROM tasks_fts WHERE tasks_fts MATCH 'passport'")
        .get();
    expect(results, isNotEmpty);
  });
}
