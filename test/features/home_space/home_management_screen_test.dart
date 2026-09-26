import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/bills/data/bill_repository_impl.dart';
import 'package:kosha/features/bills/domain/entities/bill.dart';
import 'package:kosha/features/home_space/data/home_management_repository_impl.dart';
import 'package:kosha/features/home_space/domain/entities/appliance.dart';
import 'package:kosha/features/home_space/domain/entities/home_utility.dart';
import 'package:kosha/features/home_space/domain/entities/maintenance_job.dart';
import 'package:kosha/features/home_space/presentation/home_management_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DriftHomeManagementRepository repository;
  late DriftBillRepository bills;

  setUp(() {
    db = testDatabase();
    repository = testHomeManagementRepository(db);
    bills = testBillRepository(db);
  });

  tearDown(() => db.close());

  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      wrapPushedScreen(const HomeManagementScreen(), db: db),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('with nothing added yet each section says so', (tester) async {
    await pumpScreen(tester);

    expect(
      find.textContaining('Link a bill to see it here'),
      findsOneWidget,
    );
    expect(find.text('Nothing being worked on.'), findsOneWidget);
    expect(find.text('No appliances on record yet.'), findsOneWidget);
    await settleAndDispose(tester);
  });

  group('utilities', () {
    test('adding one links the bill and reading excludes a deleted one',
        () async {
      final bill = await bills.create(
        const NewBill(name: 'Electricity', amountMinor: 185000),
      );

      final utility = await repository.addUtility(
        NewHomeUtility(name: 'Electricity', iconKey: 'bolt', billId: bill.id),
      );
      expect(await repository.watchUtilities().first, hasLength(1));

      await bills.softDelete(bill.id);
      expect(await repository.watchUtilities().first, isEmpty);

      // Restoring the bill is not enough on its own to prove the earlier
      // assertion wasn't a fluke — the utility row itself is still there.
      final row = await (db.select(db.homeUtilities)
            ..where((u) => u.id.equals(utility.id)))
          .getSingleOrNull();
      expect(row, isNotNull);
    });
  });

  testWidgets('adding a maintenance job shows it with an Upcoming pill',
      (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.byTooltip('Add maintenance job'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'e.g. AC service'),
      'AC service',
    );
    await tester.pump();
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('AC service'), findsOneWidget);
    expect(find.text('Upcoming'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('promoting a job to a task creates one and marks it promoted',
      (tester) async {
    await repository.createJob(const NewMaintenanceJob(title: 'AC service'));
    await pumpScreen(tester);

    await tester.tap(find.byTooltip('Make a task'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Make a task'), findsNothing);
    final tasks = await tester.runAsync(
      () => testRepository(db).watchRecent(limit: 10).first,
    );
    expect(tasks!.map((t) => t.title), contains('AC service'));
    await settleAndDispose(tester);
  });

  testWidgets('adding an appliance shows its warranty label', (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.byTooltip('Add appliance'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'e.g. Refrigerator'),
      'Refrigerator',
    );
    await tester.pump();
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Refrigerator'), findsOneWidget);
    expect(find.text('No warranty on record'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('an appliance whose warranty is expiring shows the pill',
      (tester) async {
    await repository.createAppliance(
      NewAppliance(
        name: 'Water purifier',
        warrantyTill: DateTime(2026, 9, 19),
      ),
    );

    await pumpScreen(tester);

    expect(find.text('Expiring'), findsOneWidget);
    await settleAndDispose(tester);
  });
}
