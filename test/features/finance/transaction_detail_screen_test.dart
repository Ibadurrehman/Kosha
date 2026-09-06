import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/bills/domain/entities/bill.dart';
import 'package:kosha/features/finance/data/transaction_repository_impl.dart';
import 'package:kosha/features/finance/domain/entities/transaction.dart';
import 'package:kosha/features/finance/presentation/transaction_detail_screen.dart';
import 'package:kosha/features/finance/presentation/transaction_edit_screen.dart';

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
    int amountMinor = 245050,
    TransactionType type = TransactionType.expense,
    String? category = 'Groceries',
    TransactionMethod? method = TransactionMethod.upi,
    String? label = 'Big Bazaar',
    String? note,
  }) =>
      repository.create(
        NewTransaction(
          amountMinor: amountMinor,
          type: type,
          date: testToday,
          category: category,
          method: method,
          label: label,
          note: note,
        ),
      );

  group('detail', () {
    testWidgets('shows the amount to the paise and every field', (tester) async {
      final transaction = await add(note: 'Weekly shop');

      await tester.pumpWidget(
        wrapScreen(
          TransactionDetailScreen(transactionId: transaction.id),
          db: db,
          now: testNow,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('−₹2,450.50'), findsOneWidget);
      expect(find.text('Big Bazaar'), findsOneWidget);
      expect(find.text('Expense'), findsOneWidget);
      expect(find.text('4 Sep 2026'), findsOneWidget);
      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('UPI'), findsOneWidget);
      expect(find.text('Weekly shop'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('income is signed and coloured as money coming in',
        (tester) async {
      final transaction = await add(
        amountMinor: 8500000,
        type: TransactionType.income,
        category: null,
        label: 'Salary',
      );

      await tester.pumpWidget(
        wrapScreen(
          TransactionDetailScreen(transactionId: transaction.id),
          db: db,
          now: testNow,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('+₹85,000.00'), findsOneWidget);
      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Uncategorised'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('an expense written by a bill payment links back to the bill',
        (tester) async {
      final bills = testBillRepository(db);
      final bill = await bills.create(
        NewBill(
          name: 'Electricity',
          amountMinor: 185000,
          nextDue: DateTime(2026, 9, 10),
          frequencyRule: 'FREQ=MONTHLY',
        ),
      );
      final paid = await bills.markPaid(bill.id);

      await tester.pumpWidget(
        wrapScreen(
          TransactionDetailScreen(transactionId: paid.transactionId!),
          db: db,
          now: testNow,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('PAID TOWARDS'), findsOneWidget);
      expect(find.text('Electricity'), findsWidgets);
      await settleAndDispose(tester);
    });

    testWidgets('Delete asks first and can be dismissed', (tester) async {
      final transaction = await add();

      await tester.pumpWidget(
        wrapScreen(
          TransactionDetailScreen(transactionId: transaction.id),
          db: db,
          now: testNow,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Delete'));
      await tester.pumpAndSettle();
      expect(find.text('Delete this transaction?'), findsOneWidget);

      await tester.tap(find.text('Keep it'));
      await tester.pumpAndSettle();

      expect(await repository.findById(transaction.id), isNotNull);
      expect(find.text('Big Bazaar'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('a deleted transaction explains itself instead of going blank',
        (tester) async {
      final transaction = await add();

      await tester.pumpWidget(
        wrapScreen(
          TransactionDetailScreen(transactionId: transaction.id),
          db: db,
          now: testNow,
        ),
      );
      await tester.pumpAndSettle();

      await repository.softDelete(transaction.id);
      await tester.pumpAndSettle();

      expect(find.text('This transaction is gone'), findsOneWidget);
      await settleAndDispose(tester);
    });
  });

  group('edit', () {
    testWidgets('opens pre-filled and saves the changes', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final transaction = await add(amountMinor: 245000, note: 'Weekly shop');

      await tester.pumpWidget(
        wrapPushedScreen(
          TransactionEditScreen(transactionId: transaction.id),
          db: db,
          now: testNow,
        ),
      );
      await tester.pumpAndSettle();

      // The keypad's own rendering of the stored amount.
      expect(find.text('₹2450'), findsOneWidget);
      expect(find.text('Big Bazaar'), findsOneWidget);
      expect(find.text('Weekly shop'), findsOneWidget);

      // Append a digit: 2450 → 24500.
      await tester.tap(find.widgetWithText(InkWell, '0').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save changes'));
      await tester.pumpAndSettle();

      final saved = await repository.findById(transaction.id);
      expect(saved!.amountMinor, 2450000);
      expect(saved.createdAt, transaction.createdAt);
      await settleAndDispose(tester);
    });

    testWidgets('a category the user has since deleted stays selectable',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      // "Petrol" is not in the seeded list, so it only appears because the
      // transaction itself carries it.
      final transaction = await add(category: 'Petrol');

      await tester.pumpWidget(
        wrapPushedScreen(
          TransactionEditScreen(transactionId: transaction.id),
          db: db,
          now: testNow,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Petrol'), findsOneWidget);
      await settleAndDispose(tester);
    });
  });
}
