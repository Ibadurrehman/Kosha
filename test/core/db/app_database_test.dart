import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.withExecutor(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('creates the schema and round-trips a setting', () async {
    await db.into(db.settings).insert(
          SettingsCompanion.insert(key: 'theme_mode', value: '"dark"'),
        );
    final row = await (db.select(db.settings)..where((s) => s.key.equals('theme_mode'))).getSingle();
    expect(row.value, '"dark"');
    expect(row.updatedAt, isNotNull);
  });

  test('foreign keys are enabled on open', () async {
    final result = await db.customSelect('PRAGMA foreign_keys').getSingle();
    expect(result.read<int>('foreign_keys'), 1);
  });

  test('schema version is 5', () {
    // v1 settings, v2 tasks, v3 activity history, v4 profiles, v5 dashboard
    // sections. Bump this with every migration so the upgrade path in
    // AppDatabase.migration is never skipped by accident.
    expect(db.schemaVersion, 5);
  });

  test('a fresh install can insert a profile and a dashboard section',
      () async {
    final now = DateTime(2026, 9, 4);
    await db.into(db.profiles).insert(
          ProfilesCompanion.insert(
            id: 'local',
            joinedAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db.into(db.dashboardSections).insert(
          DashboardSectionsCompanion.insert(
            key: 'today',
            sortOrder: 0,
            updatedAt: now,
          ),
        );
    expect(await db.select(db.profiles).getSingle(), isNotNull);
    expect(await db.select(db.dashboardSections).getSingle(), isNotNull);
  });

  test('an upgrade from v3 adds profiles and dashboard sections', () async {
    // Mirrors the "v1 database gains the tasks table" migration test in
    // task_repository_test.dart: a real file so the upgrade runs against a
    // database that was actually closed and reopened, not a fresh in-memory
    // one that never had a chance to be behind.
    final dir = Directory.systemTemp.createTempSync('kosha_migration_v3');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File(p.join(dir.path, 'kosha.sqlite'));

    final legacy = sqlite3.open(file.path);
    legacy.execute(
      'CREATE TABLE settings (key TEXT NOT NULL, value TEXT NOT NULL, '
      'updated_at INTEGER NOT NULL, PRIMARY KEY (key));',
    );
    legacy.execute('PRAGMA user_version = 3;');
    legacy.close();

    final upgraded = AppDatabase.withExecutor(NativeDatabase(file));
    addTearDown(upgraded.close);

    final now = DateTime(2026, 9, 4);
    await upgraded.into(upgraded.profiles).insert(
          ProfilesCompanion.insert(
            id: 'local',
            joinedAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        );
    await upgraded.into(upgraded.dashboardSections).insert(
          DashboardSectionsCompanion.insert(
            key: 'today',
            sortOrder: 0,
            updatedAt: now,
          ),
        );

    expect((await upgraded.select(upgraded.profiles).get()).single.id, 'local');
    expect(
      (await upgraded.select(upgraded.dashboardSections).get()).single.key,
      'today',
    );
  });
}
