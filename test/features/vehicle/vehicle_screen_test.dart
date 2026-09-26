import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/vehicle/data/vehicle_repository_impl.dart';
import 'package:kosha/features/vehicle/domain/entities/vehicle.dart';
import 'package:kosha/features/vehicle/domain/entities/vehicle_renewal.dart';
import 'package:kosha/features/vehicle/presentation/vehicle_screen.dart';

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
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(wrapPushedScreen(const VehicleScreen(), db: db));
    await tester.pumpAndSettle();
  }

  testWidgets('with nothing added yet it invites the first vehicle',
      (tester) async {
    await pumpScreen(tester);

    expect(find.text('No vehicle yet'), findsOneWidget);
    expect(find.text('Add vehicle'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('adding one from the empty state shows its header and stats',
      (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.text('Add vehicle'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Name, e.g. My Honda City'),
      'My Honda City',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Make and model'),
      'Honda City',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Registration number'),
      'MH 02 CJ 4471',
    );
    // enterText marks the form controller's listener dirty but does not
    // itself trigger a rebuild — without this pump, Create's onPressed is
    // still evaluated against the stale (all-empty) form and the tap below
    // hits a disabled button.
    await tester.pump();
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('My Honda City'), findsOneWidget);
    expect(find.textContaining('MH 02 CJ 4471'), findsOneWidget);
    expect(find.text('ODOMETER'), findsOneWidget);
    expect(find.text('INSURANCE'), findsOneWidget);
    expect(find.text('PUC'), findsOneWidget);
    expect(find.text('Not set'), findsNWidgets(2));
    expect(find.text('No service logged yet.'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('a renewal shows its status pill and due label', (tester) async {
    final vehicle = await hondaCity();
    await repository.upsertRenewal(
      vehicle.id,
      VehicleRenewalKind.insurance,
      validTill: DateTime(2026, 12, 15),
    );

    await pumpScreen(tester);

    expect(find.text('Valid'), findsOneWidget);
    expect(find.text('Due 15 Dec'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('logging a service adds it to the history and bumps the odometer',
      (tester) async {
    await hondaCity();
    await pumpScreen(tester);

    await tester.tap(find.widgetWithText(InkWell, 'Service').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Odometer reading').first,
      '38400',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'e.g. Periodic service'),
      'Periodic service',
    );
    await tester.pump();
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Periodic service'), findsOneWidget);
    expect(find.textContaining('38400 km'), findsWidgets);
    await settleAndDispose(tester);
  });

  testWidgets('logging fuel updates the fuel-this-month card', (tester) async {
    await hondaCity();
    await pumpScreen(tester);

    await tester.tap(find.widgetWithText(InkWell, 'Fuel').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Litres filled'),
      '30',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Odometer reading').first,
      '42500',
    );
    await tester.pump();
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
    await settleAndDispose(tester);
  });
}
