import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/services/settings/settings_store.dart';
import 'package:kosha/core/utils/clock.dart';
import 'package:kosha/features/finance/domain/entities/transaction.dart';
import 'package:kosha/features/finance/domain/finance_settings.dart';
import 'package:kosha/features/finance/presentation/finance_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());
  tearDown(() => db.close());

  Future<void> openSheet(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(wrapScreen(const FinanceScreen(), db: db, now: testNow));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('monthly budget'));
    await tester.pumpAndSettle();
  }

  testWidgets('typing a budget stores it and shows it as "Budgeted"',
      (tester) async {
    await openSheet(tester);
    expect(find.text('Monthly budget'), findsOneWidget);

    // 85000 on the keypad.
    for (final key in ['8', '5', '0', '0', '0']) {
      await tester.tap(find.widgetWithText(InkWell, key).last);
      await tester.pump();
    }
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final store = SettingsStore(db, FixedClock(testNow));
    expect(await readMonthlyBudgetMinor(store), 8500000);
    expect(find.text('Monthly budget set to ₹85,000'), findsOneWidget);
    expect(find.text('Budgeted'), findsOneWidget);
    expect(find.text('₹85,000'), findsWidgets);
    await settleAndDispose(tester);
  });

  testWidgets('a real income transaction wins over the budget fallback',
      (tester) async {
    final store = SettingsStore(db, FixedClock(testNow));
    await writeMonthlyBudgetMinor(store, 8500000);
    await testTransactionRepository(db).create(
      NewTransaction(
        amountMinor: 9000000,
        type: TransactionType.income,
        date: testToday,
        // Labelled so the row is not also called "Income", which would make
        // the stat-column assertion below ambiguous.
        label: 'Salary',
      ),
    );

    await tester.pumpWidget(wrapScreen(const FinanceScreen(), db: db, now: testNow));
    await tester.pumpAndSettle();

    // ADR 0006: the fallback only fills in while the month has no income.
    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Budgeted'), findsNothing);
    expect(find.text('₹90,000'), findsWidgets);
    await settleAndDispose(tester);
  });

  testWidgets('the sheet opens pre-filled with what is already stored',
      (tester) async {
    await writeMonthlyBudgetMinor(SettingsStore(db, FixedClock(testNow)), 5000000);

    await openSheet(tester);

    expect(find.text('₹50000'), findsOneWidget);
    await settleAndDispose(tester);
  });
}
