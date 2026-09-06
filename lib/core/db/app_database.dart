import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/bills/data/bill_table.dart';
import '../../features/bills/domain/entities/bill.dart';
import '../../features/calendar/data/event_table.dart';
import '../../features/finance/data/transaction_category_table.dart';
import '../../features/finance/data/transaction_table.dart';
// Enum columns: the generated part file resolves these through this library's
// imports, so they must be imported here even though this file never names them.
import '../../features/finance/domain/entities/transaction.dart';
import '../../features/finance/domain/entities/transaction_category.dart';
import '../../features/home/data/dashboard_section_table.dart';
import '../../features/notifications/data/notification_table.dart';
import '../../features/onboarding/data/profile_table.dart';
import '../../features/tasks/data/activity_table.dart';
import '../../features/tasks/data/task_table.dart';
import '../../features/tasks/domain/entities/activity_entry.dart';
import '../../features/tasks/domain/entities/task.dart';
import '../models/priority.dart';
import '../services/notifications/scheduled_reminder.dart';

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
  tables: [
    Settings,
    Tasks,
    ActivityEntries,
    Profiles,
    DashboardSections,
    Events,
    Notifications,
    Transactions,
    TransactionCategories,
    Bills,
    Payments,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For tests: pass `NativeDatabase.memory()` or any other executor.
  AppDatabase.withExecutor(super.executor);

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createTasksFts();
        },
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
          // v7 (Phase 1 week 4): the notifications inbox.
          if (from < 7) {
            await m.createTable(notifications);
            await m.createIndex(notificationsDedupe);
            await m.createIndex(notificationsCreated);
          }
          // v8 (Phase 1 week 4): task search. A fresh install gets the FTS
          // table via onCreate with zero rows to backfill; an upgrading
          // install has existing tasks the index has never seen, so it needs
          // the one-time backfill below or search returns nothing until each
          // task happens to be re-saved.
          if (from < 8) {
            await _createTasksFts();
            await customStatement(
              'INSERT INTO tasks_fts(rowid, title, description, category) '
              'SELECT rowid, title, description, category FROM tasks;',
            );
          }
          // v9 (Phase 2): transactions.
          if (from < 9) {
            await m.createTable(transactions);
            await m.createIndex(transactionsDate);
            await m.createIndex(transactionsSpace);
          }
          // v10 (Phase 2): user-editable categories. Nothing is backfilled —
          // the repository seeds a kind's defaults the first time it is read,
          // so an upgrading install picks them up on its next visit to
          // Finance with the same `Clock` every other write uses.
          if (from < 10) {
            await m.createTable(transactionCategories);
            await m.createIndex(categoriesKindSort);
          }
          // v11 (Phase 2): bills, subscriptions and their payment history.
          if (from < 11) {
            await m.createTable(bills);
            await m.createIndex(billsNextDue);
            await m.createIndex(billsSpace);
            await m.createTable(payments);
            await m.createIndex(paymentsBill);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Raw SQL: drift 2.34 has no Dart-level FTS5 table API. An external-content
  /// table over `tasks` (non-integer primary key `id`, so `content_rowid`
  /// points at SQLite's own implicit `rowid` instead) plus the 3 triggers
  /// that keep it in sync. The delete/update triggers must use FTS5's
  /// `'delete'` special-command form for the old row — a plain single
  /// statement against an external-content shadow table is invalid and would
  /// silently corrupt the index.
  Future<void> _createTasksFts() async {
    await customStatement(
      'CREATE VIRTUAL TABLE IF NOT EXISTS tasks_fts USING fts5('
      'title, description, category, '
      "content='tasks', content_rowid='rowid', "
      "tokenize='unicode61 remove_diacritics 2'"
      ');',
    );
    await customStatement(
      'CREATE TRIGGER IF NOT EXISTS tasks_fts_insert AFTER INSERT ON tasks BEGIN '
      'INSERT INTO tasks_fts(rowid, title, description, category) '
      'VALUES (new.rowid, new.title, new.description, new.category); '
      'END;',
    );
    await customStatement(
      'CREATE TRIGGER IF NOT EXISTS tasks_fts_delete AFTER DELETE ON tasks BEGIN '
      'INSERT INTO tasks_fts(tasks_fts, rowid, title, description, category) VALUES'
      "('delete', old.rowid, old.title, old.description, old.category); "
      'END;',
    );
    await customStatement(
      'CREATE TRIGGER IF NOT EXISTS tasks_fts_update AFTER UPDATE ON tasks BEGIN '
      'INSERT INTO tasks_fts(tasks_fts, rowid, title, description, category) VALUES'
      "('delete', old.rowid, old.title, old.description, old.category); "
      'INSERT INTO tasks_fts(rowid, title, description, category) '
      'VALUES (new.rowid, new.title, new.description, new.category); '
      'END;',
    );
  }

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
