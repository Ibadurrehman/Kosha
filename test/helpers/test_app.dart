import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/services/notifications/reminder_scheduler.dart';
import 'package:kosha/core/services/settings/settings_store.dart';
import 'package:kosha/core/theme/kosha_theme.dart';
import 'package:kosha/core/utils/clock.dart';
import 'package:kosha/features/bills/data/bill_repository_impl.dart';
import 'package:kosha/features/finance/data/transaction_category_repository_impl.dart';
import 'package:kosha/features/finance/data/transaction_repository_impl.dart';
import 'package:kosha/features/onboarding/data/profile_repository_impl.dart';
import 'package:kosha/features/tasks/data/task_repository_impl.dart';
import 'package:kosha/shared/state/toast_controller.dart';
import 'package:kosha/shared/widgets/toast_host.dart';

/// Friday, 4 September 2026 at 9:41 am — the moment the prototype is drawn at.
final DateTime testNow = DateTime(2026, 9, 4, 9, 41);

/// Local midnight of [testNow].
final DateTime testToday = DateTime(2026, 9, 4);

/// A database that lives for one test. Close it with `addTearDown(db.close)`.
AppDatabase testDatabase() => AppDatabase.withExecutor(NativeDatabase.memory());

/// Seeds a completed profile so a full-app test (through [wrapApp]) lands
/// directly on the screen under test instead of onboarding. Screen-level
/// tests using [wrapScreen]/[wrapPushedScreen] never build the router at all,
/// so they are unaffected either way — only a test that pumps the real
/// `KoshaApp` needs this.
Future<void> seedCompletedProfile(AppDatabase db, {DateTime? now}) {
  final clock = FixedClock(now ?? testNow);
  return DriftProfileRepository(db, clock, SettingsStore(db, clock))
      .completeOnboarding();
}

/// A repository on [db] with a fixed clock and, unless one is passed, a
/// scheduler that does nothing.
DriftTaskRepository testRepository(
  AppDatabase db, {
  DateTime? now,
  ReminderScheduler? scheduler,
}) =>
    DriftTaskRepository(
      db,
      FixedClock(now ?? testNow),
      scheduler ?? const NoopReminderScheduler(),
    );

DriftTransactionRepository testTransactionRepository(
  AppDatabase db, {
  DateTime? now,
}) =>
    DriftTransactionRepository(db, FixedClock(now ?? testNow));

DriftTransactionCategoryRepository testCategoryRepository(
  AppDatabase db, {
  DateTime? now,
}) =>
    DriftTransactionCategoryRepository(db, FixedClock(now ?? testNow));

/// A bill repository on [db]. Shares the [TransactionRepository] Finance uses
/// so a payment's expense lands in the same database the assertions read.
DriftBillRepository testBillRepository(
  AppDatabase db, {
  DateTime? now,
  ReminderScheduler? scheduler,
}) =>
    DriftBillRepository(
      db,
      FixedClock(now ?? testNow),
      scheduler ?? const NoopReminderScheduler(),
      testTransactionRepository(db, now: now),
    );

/// Wraps [app] in a scope with a throwaway database, a fixed clock and no real
/// notifications.
///
/// Riverpod 3 does not export the `Override` type, so the override list cannot
/// be returned from a helper — it is built here instead.
Widget wrapApp(
  Widget app, {
  required AppDatabase db,
  DateTime? now,
  ReminderScheduler? scheduler,
}) {
  return ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      clockProvider.overrideWithValue(FixedClock(now ?? testNow)),
      googleFontsEnabledProvider.overrideWithValue(false),
      reminderSchedulerProvider.overrideWithValue(
        scheduler ?? const NoopReminderScheduler(),
      ),
    ],
    child: app,
  );
}

/// Hosts one screen with the Kosha theme and the toast overlay, so widget tests
/// exercise the same wiring the app uses.
Widget wrapScreen(
  Widget screen, {
  required AppDatabase db,
  DateTime? now,
  ReminderScheduler? scheduler,
}) {
  return wrapApp(
    MaterialApp(
      theme: buildKoshaTheme(Brightness.light, useGoogleFonts: false),
      home: screen,
      builder: (context, child) =>
          ToastHost(child: child ?? const SizedBox.shrink()),
    ),
    db: db,
    now: now,
    scheduler: scheduler,
  );
}

/// Hosts [screen] one level deep inside a real router, so a screen that ends
/// with `context.pop()` has somewhere to go back to.
///
/// Call it from inside a test: the router is disposed on tear-down.
Widget wrapPushedScreen(
  Widget screen, {
  required AppDatabase db,
  DateTime? now,
}) {
  final router = GoRouter(
    initialLocation: '/screen',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: Center(child: Text('behind'))),
        routes: [GoRoute(path: 'screen', builder: (_, _) => screen)],
      ),
    ],
  );
  addTearDown(router.dispose);

  return wrapApp(
    MaterialApp.router(
      routerConfig: router,
      theme: buildKoshaTheme(Brightness.light, useGoogleFonts: false),
      builder: (context, child) =>
          ToastHost(child: child ?? const SizedBox.shrink()),
    ),
    db: db,
    now: now,
  );
}

/// Ends a widget test cleanly.
///
/// Lets any toast timer expire, then unmounts the tree so Riverpod disposes the
/// providers: drift schedules a zero-duration timer while closing its query
/// streams, and `flutter_test` fails a test that ends with a timer pending. A
/// bare `pump()` does not drain it, so real time is elapsed here.
Future<void> settleAndDispose(WidgetTester tester) async {
  await tester.pump(ToastController.visibleFor + const Duration(seconds: 1));
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 50));
}
