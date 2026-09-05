import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/theme/kosha_theme.dart';
import 'package:kosha/core/utils/clock.dart';
import 'package:kosha/shared/state/toast_controller.dart';
import 'package:kosha/shared/widgets/toast_host.dart';

/// Friday, 4 September 2026 at 9:41 am — the moment the prototype is drawn at.
final DateTime testNow = DateTime(2026, 9, 4, 9, 41);

/// Local midnight of [testNow].
final DateTime testToday = DateTime(2026, 9, 4);

/// A database that lives for one test. Close it with `addTearDown(db.close)`.
AppDatabase testDatabase() => AppDatabase.withExecutor(NativeDatabase.memory());

/// Wraps [app] in a scope with a throwaway database and a fixed clock.
///
/// Riverpod 3 does not export the `Override` type, so the override list cannot
/// be returned from a helper — it is built here instead.
Widget wrapApp(Widget app, {required AppDatabase db, DateTime? now}) {
  return ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      clockProvider.overrideWithValue(FixedClock(now ?? testNow)),
      googleFontsEnabledProvider.overrideWithValue(false),
    ],
    child: app,
  );
}

/// Hosts one screen with the Kosha theme and the toast overlay, so widget tests
/// exercise the same wiring the app uses.
Widget wrapScreen(Widget screen, {required AppDatabase db, DateTime? now}) {
  return wrapApp(
    MaterialApp(
      theme: buildKoshaTheme(Brightness.light, useGoogleFonts: false),
      home: screen,
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
/// streams, and `flutter_test` fails a test that ends with a timer pending.
Future<void> settleAndDispose(WidgetTester tester) async {
  await tester.pump(ToastController.visibleFor + const Duration(seconds: 1));
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 50));
}
