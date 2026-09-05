import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';

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

  test('schema version is 3', () {
    // v1 settings, v2 tasks, v3 activity history. Bump this with every
    // migration so the upgrade path in AppDatabase.migration is never skipped
    // by accident.
    expect(db.schemaVersion, 3);
  });
}
