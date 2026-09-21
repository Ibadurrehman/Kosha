import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/bills/data/bill_repository_impl.dart';
import 'package:kosha/features/bills/domain/entities/bill.dart';
import 'package:kosha/features/bills/presentation/bill_detail_screen.dart';
import 'package:kosha/features/finance/domain/entities/transaction.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DriftBillRepository repository;

  setUp(() {
    db = testDatabase();
    repository = testBillRepository(db);
  });

  tearDown(() => db.close());

  Future<Bill> add({
    String name = 'Electricity',
    DateTime? nextDue,
    bool autopay = false,
    String? provider,
  }) =>
      repository.create(
        NewBill(
          name: name,
          amountMinor: 185000,
          nextDue: nextDue ?? DateTime(2026, 9, 10),
          frequencyRule: 'FREQ=MONTHLY;BYMONTHDAY=10',
          autopay: autopay,
          provider: provider,
        ),
      );

  testWidgets('shows the bill, its fields and an empty history', (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final bill = await add(provider: 'MSEDCL');

    await tester.pumpWidget(
      wrapScreen(BillDetailScreen(billId: bill.id), db: db, now: testNow),
    );
    await tester.pumpAndSettle();

    expect(find.text('Electricity'), findsOneWidget);
    expect(find.text('₹1,850.00'), findsOneWidget);
    expect(find.text('Due in 6 days'), findsOneWidget);
    expect(find.text('Monthly'), findsOneWidget);
    expect(find.text('3 days before'), findsOneWidget);
    expect(find.text('MSEDCL'), findsOneWidget);
    expect(find.text('Never'), findsOneWidget);
    expect(
      find.text('Nothing paid yet. "Pay now" records the first one.'),
      findsOneWidget,
    );
    await settleAndDispose(tester);
  });

  testWidgets('a payment appears in the history with its method', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final bill = await add();
    await repository.markPaid(
      bill.id,
      paidOn: DateTime(2026, 9, 2),
      method: TransactionMethod.upi,
    );

    await tester.pumpWidget(
      wrapScreen(BillDetailScreen(billId: bill.id), db: db, now: testNow),
    );
    await tester.pumpAndSettle();

    expect(find.text('2 Sep 2026 · UPI'), findsOneWidget);
    // The cycle advanced, so the header reads as paid rather than due.
    expect(find.text('Paid 2 Sep'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('an autopay bill offers "Mark as paid" instead of "Pay now"',
      (tester) async {
    final bill = await add(autopay: true);

    await tester.pumpWidget(
      wrapScreen(BillDetailScreen(billId: bill.id), db: db, now: testNow),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mark as paid'), findsOneWidget);
    expect(find.text('Pay now'), findsNothing);
    await settleAndDispose(tester);
  });

  testWidgets('a deleted bill says so rather than showing a blank screen',
      (tester) async {
    final bill = await add();
    await repository.softDelete(bill.id);

    await tester.pumpWidget(
      wrapScreen(BillDetailScreen(billId: bill.id), db: db, now: testNow),
    );
    await tester.pumpAndSettle();

    expect(find.text('This bill is gone'), findsOneWidget);
    await settleAndDispose(tester);
  });
}
