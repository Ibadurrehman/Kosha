import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/vehicle/data/vehicle_repository_impl.dart';
import 'package:kosha/features/vehicle/domain/entities/vehicle.dart';
import 'package:kosha/features/vehicle/domain/entities/vehicle_renewal.dart';
import 'package:kosha/features/vehicle/presentation/vehicle_renewals_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DriftVehicleRepository repository;

  setUp(() {
    db = testDatabase();
    repository = testVehicleRepository(db);
  });

  tearDown(() => db.close());

  Future<Vehicle> hondaCity() => repository.create(
        const NewVehicle(
          name: 'My Honda City',
          makeModel: 'Honda City',
          registration: 'MH 02 CJ 4471',
        ),
      );

  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      wrapPushedScreen(const VehicleRenewalsScreen(), db: db),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('lists all four kinds, unset by default', (tester) async {
    await hondaCity();
    await pumpScreen(tester);

    expect(find.text('Insurance'), findsOneWidget);
    expect(find.text('PUC'), findsOneWidget);
    expect(find.text('Registration'), findsOneWidget);
    expect(find.text('Permit'), findsOneWidget);
    expect(find.text('Not set'), findsNWidgets(4));
    await settleAndDispose(tester);
  });

  testWidgets('setting insurance opens the sheet and updates the row',
      (tester) async {
    await hondaCity();
    await pumpScreen(tester);

    await tester.tap(find.text('Insurance'));
    await tester.pumpAndSettle();

    expect(find.text('Insurance renewal'), findsOneWidget);
    await tester.tap(find.text('Pick a date'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // The date picker's default (today, accepted via OK) is inside the
    // renewal's own 30-day lead time, so it reads as Expiring rather than
    // Valid — the same "just set" shape section 6.9's PUC/insurance stats
    // read for a freshly-added renewal.
    expect(find.text('Not set'), findsNWidgets(3));
    expect(find.text('Expiring'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('an existing renewal pre-fills the sheet and renewing updates it',
      (tester) async {
    final vehicle = await hondaCity();
    await repository.upsertRenewal(
      vehicle.id,
      VehicleRenewalKind.puc,
      validTill: DateTime(2026, 9, 10),
    );

    await pumpScreen(tester);
    // Inside its own 30-day lead time (today is 2026-09-04), not past it.
    expect(find.text('Expiring'), findsOneWidget);

    await tester.tap(find.text('PUC'));
    await tester.pumpAndSettle();
    expect(find.text('10 Sep 2026'), findsOneWidget);

    await tester.tap(find.text('60 days before'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final renewals = await tester.runAsync(
      () => repository.watchRenewals(vehicle.id).first,
    );
    expect(renewals!.single.reminderOffsetDays, 60);
    await settleAndDispose(tester);
  });
}
