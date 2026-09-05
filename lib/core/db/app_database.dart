import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/tasks/data/task_table.dart';
// Enum columns: the generated part file resolves these through this library's
// imports, so they must be imported here even though this file never names them.
import '../../features/tasks/domain/entities/task.dart';
import '../models/priority.dart';

part 'app_database.g.dart';

/// Key/value store for user preferences (theme mode, reminder lead times,
/// app lock, currency…). Values are JSON-encoded strings.
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// The single local database. Feature tables are added here as each phase
/// lands; every table uses a UUID text primary key plus created_at /
/// updated_at / deleted_at so the Phase 5 sync layer needs no migration.
@DriftDatabase(tables: [Settings, Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For tests: pass `NativeDatabase.memory()` or any other executor.
  AppDatabase.withExecutor(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // v2 (Phase 1): tasks.
          if (from < 2) {
            await m.createTable(tasks);
            await m.createIndex(tasksBucket);
            await m.createIndex(tasksSpace);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  static QueryExecutor _openConnection() => driftDatabase(
        name: 'kosha',
        native: const DriftNativeOptions(
          databaseDirectory: getApplicationSupportDirectory,
        ),
      );
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
