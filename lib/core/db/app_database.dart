import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/calendar/data/event_table.dart';
import '../../features/home/data/dashboard_section_table.dart';
import '../../features/onboarding/data/profile_table.dart';
import '../../features/tasks/data/activity_table.dart';
import '../../features/tasks/data/task_table.dart';
// Enum columns: the generated part file resolves these through this library's
// imports, so they must be imported here even though this file never names them.
import '../../features/tasks/domain/entities/activity_entry.dart';
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
@DriftDatabase(
  tables: [Settings, Tasks, ActivityEntries, Profiles, DashboardSections, Events],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For tests: pass `NativeDatabase.memory()` or any other executor.
  AppDatabase.withExecutor(super.executor);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // v2 (Phase 1 week 1): tasks.
          if (from < 2) {
            await m.createTable(tasks);
            await m.createIndex(tasksBucket);
            await m.createIndex(tasksSpace);
          }
          // v3 (Phase 1 week 2): activity history.
          if (from < 3) {
            await m.createTable(activityEntries);
            await m.createIndex(activityOwner);
          }
          // v4 (Phase 1 week 3): the local profile + onboarding.
          if (from < 4) {
            await m.createTable(profiles);
          }
          // v5 (Phase 1 week 3): Home's Customize dashboard.
          if (from < 5) {
            await m.createTable(dashboardSections);
          }
          // v6 (Phase 1 week 3): Calendar events.
          if (from < 6) {
            await m.createTable(events);
            await m.createIndex(eventsStart);
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
        // Web is a local-iteration target only (see the README), but drift
        // refuses to open at all without these, and sqlite3 has to be compiled
        // to wasm because there is no pure-Dart sqlite in a browser. Both files
        // ship with the drift release pinned in pubspec.lock and live in web/;
        // `tool/fetch_web_assets.ps1` refreshes them after a drift upgrade.
        web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          driftWorker: Uri.parse('drift_worker.js'),
        ),
      );
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
