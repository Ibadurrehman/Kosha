import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/finance/data/transaction_repository_impl.dart';
import 'package:kosha/features/finance/domain/entities/transaction.dart';
import 'package:kosha/features/finance/presentation/all_transactions_screen.dart';
import 'package:kosha/shared/widgets/kosha_chip.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DriftTransactionRepository repository;

  setUp(() {
    db = testDatabase();
    repository = testTransactionRepository(db);
  });

  tearDown(() => db.close());

  Future<Transaction> add({
    required int amountMinor,
    DateTime? date,
    TransactionType type = TransactionType.expense,
    String? category,
    TransactionMethod? method,
    String? label,
  }) =>
      repository.create(
        NewTransaction(
          amountMinor: amountMinor,
          type: type,
          date: date ?? testToday,
          category: category,
          method: method,
          label: label,
        ),
      );

  /// A filter chip, not the same word where it appears in a row's subtitle —
  /// "UPI" is both a chip and part of "Groceries · UPI".
  Finder chip(String label) => find.widgetWithText(KoshaChip, label);

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      wrapScreen(const AllTransactionsScreen(), db: db, now: testNow),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the current month with an empty state', (tester) async {
    await pump(tester);

    expect(find.text('September 2026'), findsOneWidget);
    expect(find.text('Nothing this month'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('groups the month by day and totals what is shown',
      (tester) async {
    await add(amountMinor: 245000, category: 'Groceries', label: 'Big Bazaar');
    await add(amountMinor: 85000, date: DateTime(2026, 9, 3), category: 'Food');
    await add(
      amountMinor: 8500000,
      type: TransactionType.income,
      label: 'Salary',
    );

    await pump(tester);

    expect(find.text('3 transactions'), findsOneWidget);
    expect(find.text('4 Sep 2026'), findsOneWidget);
    expect(find.text('3 Sep 2026'), findsOneWidget);
    expect(find.text('Big Bazaar'), findsOneWidget);
    expect(find.text('+₹85,000'), findsWidgets);
    expect(find.text('−₹3,300'), findsWidgets);
    await settleAndDispose(tester);
  });

  testWidgets('the type chip filters to income only', (tester) async {
    await add(amountMinor: 245000, category: 'Groceries', label: 'Big Bazaar');
    // Not plain "Salary": filtering to Income swaps the category chips to the
    // income set, which has a "Salary" chip of its own, and the assertion
    // below would then match both the chip and the row.
    await add(
      amountMinor: 8500000,
      type: TransactionType.income,
      label: 'September salary',
    );

    await pump(tester);

    await tester.tap(chip('Income'));
    await tester.pumpAndSettle();

    expect(find.text('September salary'), findsOneWidget);
    expect(find.text('Big Bazaar'), findsNothing);
    expect(find.text('1 transaction'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('the method chip filters, and Clear puts everything back',
      (tester) async {
    await add(amountMinor: 245000, method: TransactionMethod.upi, label: 'By UPI');
    await add(amountMinor: 85000, method: TransactionMethod.cash, label: 'In cash');

    await pump(tester);

    await tester.tap(chip('UPI'));
    await tester.pumpAndSettle();
    expect(find.text('By UPI'), findsOneWidget);
    expect(find.text('In cash'), findsNothing);

    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    expect(find.text('In cash'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('a filter that matches nothing offers to clear itself',
      (tester) async {
    await add(amountMinor: 245000, category: 'Groceries');

    await pump(tester);

    await tester.tap(chip('Cash'));
    await tester.pumpAndSettle();

    expect(find.text('Nothing matches those filters'), findsOneWidget);
    await tester.tap(find.text('Clear filters'));
    await tester.pumpAndSettle();
    expect(find.text('1 transaction'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('stepping back a month shows that month instead', (tester) async {
    await add(amountMinor: 64000, date: DateTime(2026, 8, 31), label: 'Pharmacy');
    await add(amountMinor: 245000, label: 'This month');

    await pump(tester);
    expect(find.text('Pharmacy'), findsNothing);

    await tester.tap(find.byTooltip('Previous month'));
    await tester.pumpAndSettle();

    expect(find.text('August 2026'), findsOneWidget);
    expect(find.text('Pharmacy'), findsOneWidget);
    expect(find.text('This month'), findsNothing);
    await settleAndDispose(tester);
  });

  testWidgets('the forward arrow stops at the current month', (tester) async {
    await pump(tester);

    final forward = tester.widget<IconButton>(
      find.ancestor(
        of: find.byTooltip('Next month'),
        matching: find.byType(IconButton),
      ).first,
    );
    expect(forward.onPressed, isNull);

    await tester.tap(find.byTooltip('Previous month'));
    await tester.pumpAndSettle();

    final enabled = tester.widget<IconButton>(
      find.ancestor(
        of: find.byTooltip('Next month'),
        matching: find.byType(IconButton),
      ).first,
    );
    expect(enabled.onPressed, isNotNull);
    await settleAndDispose(tester);
  });
}
