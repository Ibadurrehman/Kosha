import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/bills/data/bill_repository_impl.dart';
import 'package:kosha/features/bills/domain/entities/bill.dart';
import 'package:kosha/features/bills/presentation/bills_screen.dart';
import 'package:kosha/shared/widgets/kosha_fab.dart';

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
    required String name,
    required DateTime? nextDue,
    int amountMinor = 185000,
    BillKind kind = BillKind.bill,
    int reminderOffsetDays = 3,
  }) =>
      repository.create(
        NewBill(
          name: name,
          amountMinor: amountMinor,
          nextDue: nextDue,
          frequencyRule: 'FREQ=MONTHLY',
          kind: kind,
          reminderOffsetDays: reminderOffsetDays,
        ),
      );

  testWidgets('shows an empty state and a zero total with no bills',
      (tester) async {
    await tester.pumpWidget(wrapScreen(const BillsScreen(), db: db, now: testNow));
    await tester.pumpAndSettle();

    expect(find.text('No bills yet'), findsOneWidget);
    expect(find.text('Nothing owed'), findsOneWidget);
    expect(find.text('₹0'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('the outstanding total skips bills that are paid', (tester) async {
    await add(name: 'Society maintenance', nextDue: DateTime(2026, 9, 1), amountMinor: 240000);
    final gas = await add(name: 'Gas cylinder', nextDue: DateTime(2026, 8, 28), amountMinor: 110500);
    await repository.markPaid(gas.id, paidOn: DateTime(2026, 8, 28));

    await tester.pumpWidget(wrapScreen(const BillsScreen(), db: db, now: testNow));
    await tester.pumpAndSettle();

    // Only the unpaid ₹2,400 counts; the gas bill advanced to its next cycle.
    expect(find.text('₹2,400'), findsWidgets);
    await settleAndDispose(tester);
  });

  testWidgets('an overdue bill shows its badge and a Pay now action',
      (tester) async {
    await add(name: 'Society maintenance', nextDue: DateTime(2026, 9, 1));

    await tester.pumpWidget(wrapScreen(const BillsScreen(), db: db, now: testNow));
    await tester.pumpAndSettle();

    expect(find.text('Society maintenance'), findsOneWidget);
    expect(find.text('Overdue by 3 days'), findsOneWidget);
    expect(find.text('Pay now'), findsOneWidget);
    expect(find.text('Manage'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('a subscription says it renews rather than falls due',
      (tester) async {
    await add(
      name: 'Netflix',
      nextDue: DateTime(2026, 9, 15),
      kind: BillKind.subscription,
      amountMinor: 64900,
    );

    await tester.pumpWidget(wrapScreen(const BillsScreen(), db: db, now: testNow));
    await tester.pumpAndSettle();

    expect(find.text('Renews 15 Sep'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('each tab filters to its own status', (tester) async {
    await add(name: 'Overdue one', nextDue: DateTime(2026, 9, 1));
    await add(name: 'Due soon one', nextDue: DateTime(2026, 9, 6));
    await add(name: 'Far off one', nextDue: DateTime(2026, 10, 20));

    await tester.pumpWidget(wrapScreen(const BillsScreen(), db: db, now: testNow));
    await tester.pumpAndSettle();

    expect(find.text('Overdue one'), findsOneWidget);
    expect(find.text('Far off one'), findsOneWidget);

    await tester.tap(find.text('Overdue'));
    await tester.pumpAndSettle();
    expect(find.text('Overdue one'), findsOneWidget);
    expect(find.text('Due soon one'), findsNothing);

    await tester.tap(find.text('Due Soon'));
    await tester.pumpAndSettle();
    expect(find.text('Due soon one'), findsOneWidget);
    expect(find.text('Overdue one'), findsNothing);

    await tester.tap(find.text('Paid'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing paid yet'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('paying a bill moves it to the Paid tab and toasts an undo',
      (tester) async {
    // The payment sheet is taller than the default 600 px test viewport.
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await add(name: 'Electricity', nextDue: DateTime(2026, 9, 10));

    await tester.pumpWidget(wrapScreen(const BillsScreen(), db: db, now: testNow));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pay now'));
    await tester.pumpAndSettle();
    expect(find.text('Pay Electricity'), findsOneWidget);

    await tester.tap(find.text('Mark as paid'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Paid ₹1,850'), findsOneWidget);
    expect(find.text('Undo'), findsOneWidget);

    await tester.tap(find.text('Paid'));
    await tester.pumpAndSettle();
    expect(find.text('Electricity'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('the FAB opens the New bill sheet', (tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(wrapScreen(const BillsScreen(), db: db, now: testNow));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(KoshaFab));
    await tester.pumpAndSettle();

    expect(find.text('New bill'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('a settled bill offers its receipt instead of paying again',
      (tester) async {
    final bill = await add(name: 'Electricity', nextDue: DateTime(2026, 9, 10));
    await repository.markPaid(bill.id);

    await tester.pumpWidget(wrapScreen(const BillsScreen(), db: db, now: testNow));
    await tester.pumpAndSettle();

    expect(find.text('View receipt'), findsOneWidget);
    expect(find.text('Pay now'), findsNothing);
    await settleAndDispose(tester);
  });
}
