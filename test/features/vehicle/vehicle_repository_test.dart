import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/spaces/domain/entities/space.dart';
import 'package:kosha/features/spaces/domain/space_repository.dart';
import 'package:kosha/features/vehicle/data/vehicle_repository_impl.dart';
import 'package:kosha/features/vehicle/domain/entities/fuel_log.dart';
import 'package:kosha/features/vehicle/domain/entities/service_record.dart';
import 'package:kosha/features/vehicle/domain/entities/vehicle.dart';
import 'package:kosha/features/vehicle/domain/entities/vehicle_renewal.dart';
import 'package:kosha/features/vehicle/domain/vehicle_renewal_reminder.dart';

import '../../helpers/fake_reminder_scheduler.dart';
import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late RecordingReminderScheduler scheduler;
  late DriftVehicleRepository repository;
  late SpaceRepository spaces;

  setUp(() {
    db = testDatabase();
    scheduler = RecordingReminderScheduler();
    spaces = testSpaceRepository(db);
    repository = testVehicleRepository(db, scheduler: scheduler);
  });

  tearDown(() => db.close());

  Future<Vehicle> hondaCity({String name = 'My Honda City'}) => repository.create(
        NewVehicle(
          name: name,
          makeModel: 'Honda City',
          registration: 'MH 02 CJ 4471',
        ),
      );

  group('create', () {
    test('stores the vehicle in the Vehicle system space', () async {
      final vehicle = await hondaCity();

      expect(vehicle.name, 'My Honda City');
      expect(vehicle.odometerKm, 0);
      expect(vehicle.isDeleted, isFalse);

      final vehicleSpace = await spaces.findBySystemKey(SystemSpace.vehicle);
      expect(vehicle.spaceId, vehicleSpace!.id);
    });

    test('a second vehicle shares the same space', () async {
      final first = await hondaCity();
      final second = await hondaCity(name: "Wife's scooter");

      expect(second.spaceId, first.spaceId);
    });
  });

  group('reading', () {
    test('watchPrimary is the oldest live vehicle', () async {
      final first = await hondaCity();
      // A distinct, later clock: the fixed one every other call in this file
      // shares would give both vehicles the same createdAt, leaving the
      // ordering to SQLite's untested tie-break rather than the one under
      // test.
      final later = testVehicleRepository(
        db,
        now: testNow.add(const Duration(minutes: 5)),
        scheduler: scheduler,
      );
      await later.create(
        const NewVehicle(
          name: 'Second car',
          makeModel: 'Honda City',
          registration: 'MH 02 CJ 0001',
        ),
      );

      expect((await repository.watchPrimary().first)!.id, first.id);
    });

    test('watchPrimary is null before anything has been added', () async {
      expect(await repository.watchPrimary().first, isNull);
    });

    test('a deleted vehicle is skipped by watchPrimary', () async {
      final vehicle = await hondaCity();
      await repository.softDelete(vehicle.id);

      expect(await repository.watchPrimary().first, isNull);
    });
  });

  group('edit', () {
    test('changes only what it is given', () async {
      final vehicle = await hondaCity();

      final edited = await repository.edit(
        vehicle.id,
        odometerKm: 42800,
        registration: 'MH 02 CJ 9999',
      );

      expect(edited.odometerKm, 42800);
      expect(edited.registration, 'MH 02 CJ 9999');
      expect(edited.name, 'My Honda City');
      expect(edited.makeModel, 'Honda City');
    });
  });

  group('delete and restore', () {
    test('cancels every renewal reminder, and restore re-syncs them',
        () async {
      final vehicle = await hondaCity();
      await repository.upsertRenewal(
        vehicle.id,
        VehicleRenewalKind.insurance,
        validTill: DateTime(2026, 12, 15),
      );
      scheduler.clear();

      await repository.softDelete(vehicle.id);
      expect(scheduler.cancelled, hasLength(1));

      await repository.restore(vehicle.id);
      final renewals = await repository.watchRenewals(vehicle.id).first;
      expect(scheduler.latestFor(renewals.single.id), isNotNull);
    });
  });

  group('renewals', () {
    test('upsert creates then updates the same row in place', () async {
      final vehicle = await hondaCity();

      final created = await repository.upsertRenewal(
        vehicle.id,
        VehicleRenewalKind.insurance,
        validTill: DateTime(2026, 12, 15),
      );
      final renewed = await repository.upsertRenewal(
        vehicle.id,
        VehicleRenewalKind.insurance,
        validTill: DateTime(2027, 12, 15),
      );

      expect(renewed.id, created.id);
      final all = await repository.watchRenewals(vehicle.id).first;
      expect(all, hasLength(1));
      expect(all.single.validTill, DateTime(2027, 12, 15));
    });

    test('schedules a reminder ahead of validTill', () async {
      final vehicle = await hondaCity();

      final renewal = await repository.upsertRenewal(
        vehicle.id,
        VehicleRenewalKind.puc,
        validTill: DateTime(2026, 11, 2),
        reminderOffsetDays: 10,
      );

      expect(
        scheduler.latestFor(renewal.id)!.fireAt,
        DateTime(2026, 10, 23, vehicleRenewalReminderHour),
      );
    });

    test(
        'needing attention spans every live vehicle and excludes a deleted one',
        () async {
      final live = await hondaCity();
      final deleted = await hondaCity(name: 'Sold car');
      final urgent = await repository.upsertRenewal(
        live.id,
        VehicleRenewalKind.puc,
        validTill: DateTime(2026, 9, 10),
      );
      await repository.upsertRenewal(
        deleted.id,
        VehicleRenewalKind.puc,
        validTill: DateTime(2026, 9, 10),
      );
      await repository.upsertRenewal(
        live.id,
        VehicleRenewalKind.insurance,
        validTill: DateTime(2030, 1, 1),
      );
      await repository.softDelete(deleted.id);

      final result = await repository
          .watchRenewalsNeedingAttention(today: testToday)
          .first;
      expect(result.map((r) => r.id), [urgent.id]);
    });

    test("due-between excludes a deleted vehicle's renewals", () async {
      final live = await hondaCity();
      final deleted = await hondaCity(name: 'Sold car');
      final inWindow = await repository.upsertRenewal(
        live.id,
        VehicleRenewalKind.registration,
        validTill: DateTime(2026, 9, 20),
      );
      await repository.upsertRenewal(
        deleted.id,
        VehicleRenewalKind.registration,
        validTill: DateTime(2026, 9, 20),
      );
      await repository.softDelete(deleted.id);

      final result = await repository
          .watchRenewalsDueBetween(DateTime(2026, 9, 1), DateTime(2026, 10, 1))
          .first;
      expect(result.map((r) => r.id), [inWindow.id]);
    });
  });

  group('service history', () {
    test('adding a record bumps the odometer when it reads higher', () async {
      final vehicle = await hondaCity();

      await repository.addServiceRecord(
        vehicle.id,
        NewServiceRecord(
          date: DateTime(2026, 6, 12),
          odometerKm: 38400,
          description: 'Periodic service',
          costMinor: 845000,
        ),
      );

      final updated = await repository.findById(vehicle.id);
      expect(updated!.odometerKm, 38400);
    });

    test('a lower reading never moves the odometer backwards', () async {
      final vehicle = await hondaCity();
      await repository.edit(vehicle.id, odometerKm: 40000);

      await repository.addServiceRecord(
        vehicle.id,
        NewServiceRecord(
          date: DateTime(2025, 1, 1),
          odometerKm: 10000,
          description: 'Old receipt entered late',
          costMinor: 500000,
        ),
      );

      final updated = await repository.findById(vehicle.id);
      expect(updated!.odometerKm, 40000);
    });

    test('newest service first', () async {
      final vehicle = await hondaCity();
      await repository.addServiceRecord(
        vehicle.id,
        NewServiceRecord(
          date: DateTime(2025, 12, 18),
          odometerKm: 29800,
          description: 'Tyre rotation',
          costMinor: 90000,
        ),
      );
      await repository.addServiceRecord(
        vehicle.id,
        NewServiceRecord(
          date: DateTime(2026, 3, 4),
          odometerKm: 33100,
          description: 'Brake pads',
          costMinor: 520000,
        ),
      );

      final history = await repository.watchServiceHistory(vehicle.id).first;
      expect(
        history.map((s) => s.description),
        ['Brake pads', 'Tyre rotation'],
      );
    });
  });

  group('fuel logs', () {
    test('adding a log bumps the odometer and reads oldest first', () async {
      final vehicle = await hondaCity();
      await repository.addFuelLog(
        vehicle.id,
        NewFuelLog(
          date: DateTime(2026, 9, 3),
          litres: 30,
          costMinor: 520000,
          odometerKm: 42500,
        ),
      );
      await repository.addFuelLog(
        vehicle.id,
        NewFuelLog(
          date: DateTime(2026, 9, 10),
          litres: 28,
          costMinor: 500000,
          odometerKm: 42800,
        ),
      );

      final logs = await repository.watchFuelLogs(vehicle.id).first;
      expect(logs.map((f) => f.odometerKm), [42500, 42800]);

      final updated = await repository.findById(vehicle.id);
      expect(updated!.odometerKm, 42800);
    });
  });
}
