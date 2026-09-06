import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/utils/clock.dart';
import 'package:kosha/features/finance/data/transaction_repository_impl.dart';
import 'package:kosha/features/finance/domain/entities/transaction.dart';
import 'package:kosha/features/finance/presentation/finance_screen.dart';
import 'package:kosha/shared/widgets/kosha_fab.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DriftTransactionRepository repository;

  setUp(() {
    db = testDatabase();
    repository = DriftTransactionRepository(db, FixedClock(testNow));
  });

  tearDown(() => db.close());

  testWidgets('shows an empty state and zeroed stats with no transactions',
      (tester) async {
    await tester.pumpWidget(wrapScreen(const FinanceScreen(), db: db, now: testNow));
    await tester.pumpAndSettle();

    expect(find.text('No transactions yet'), findsOneWidget);
    expect(find.text('No expenses logged this month yet.'), findsOneWidget);
    expect(find.text('₹0'), findsWidgets);
    await settleAndDispose(tester);
  });

  testWidgets('shows this month totals, category bars and recent transactions',
      (tester) async {
    await repository.create(
      NewTransaction(
        amountMinor: 45000,
        type: TransactionType.expense,
        date: testToday,
        category: 'Groceries',
      ),
    );
    await repository.create(
      NewTransaction(
        amountMinor: 8500000,
        type: TransactionType.income,
        date: testToday,
      ),
    );

    await tester.pumpWidget(wrapScreen(const FinanceScreen(), db: db, now: testNow));
    await tester.pumpAndSettle();

    expect(find.text('Income'), findsWidgets);
    expect(find.text('₹85,000'), findsOneWidget);
    expect(find.text('₹450'), findsWidgets);
    expect(find.text('Groceries'), findsWidgets);
    await settleAndDispose(tester);
  });

  testWidgets('falls back to the monthly budget when there is no income yet',
      (tester) async {
    await repository.create(
      NewTransaction(
        amountMinor: 45000,
        type: TransactionType.expense,
        date: testToday,
        category: 'Groceries',
      ),
    );

    await tester.pumpWidget(wrapScreen(const FinanceScreen(), db: db, now: testNow));
    await tester.pumpAndSettle();

    expect(find.text('Budgeted'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('an overspent month shows Remaining with a minus sign',
      (tester) async {
    // No income logged and no budget set, so displayed income is ₹0 and any
    // expense overspends it — Money.inr always renders a positive magnitude,
    // so the screen must add the sign itself or this would read as money
    // still left instead of a deficit.
    await repository.create(
      NewTransaction(
        amountMinor: 45000,
        type: TransactionType.expense,
        date: testToday,
        category: 'Groceries',
      ),
    );

    await tester.pumpWidget(wrapScreen(const FinanceScreen(), db: db, now: testNow));
    await tester.pumpAndSettle();

    expect(find.text('-₹450'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('the Bills action toasts that it is arriving later', (tester) async {
    await tester.pumpWidget(wrapScreen(const FinanceScreen(), db: db, now: testNow));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Bills'));
    await tester.pump();
    expect(find.text('Arriving in a later phase'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('the FAB opens the New expense sheet', (tester) async {
    // The sheet is taller than the default 600 px test viewport; keep the
    // default width so the Finance screen underneath still fits its rows.
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(wrapScreen(const FinanceScreen(), db: db, now: testNow));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(KoshaFab));
    await tester.pumpAndSettle();

    expect(find.text('New expense'), findsOneWidget);
    await settleAndDispose(tester);
  });
}
