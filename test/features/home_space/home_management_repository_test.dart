import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/bills/data/bill_repository_impl.dart';
import 'package:kosha/features/bills/domain/entities/bill.dart';
import 'package:kosha/features/home_space/data/home_management_repository_impl.dart';
import 'package:kosha/features/home_space/domain/appliance_reminder.dart';
import 'package:kosha/features/home_space/domain/entities/appliance.dart';
import 'package:kosha/features/home_space/domain/entities/home_utility.dart';
import 'package:kosha/features/home_space/domain/entities/maintenance_job.dart';
import 'package:kosha/features/spaces/domain/entities/space.dart';
import 'package:kosha/features/spaces/domain/space_repository.dart';

import '../../helpers/fake_reminder_scheduler.dart';
import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late RecordingReminderScheduler scheduler;
  late DriftHomeManagementRepository repository;
  late DriftBillRepository bills;
  late SpaceRepository spaces;

  setUp(() {
    db = testDatabase();
    scheduler = RecordingReminderScheduler();
    spaces = testSpaceRepository(db);
    bills = testBillRepository(db);
    repository = testHomeManagementRepository(db, scheduler: scheduler);
  });

  tearDown(() => db.close());

  Future<Bill> electricity() =>
      bills.create(const NewBill(name: 'Electricity', amountMinor: 185000));

  group('utilities', () {
    test('links a bill in the Home system space', () async {
      final bill = await electricity();

      final utility = await repository.addUtility(
        NewHomeUtility(name: 'Electricity', iconKey: 'bolt', billId: bill.id),
      );

      final homeSpace = await spaces.findBySystemKey(SystemSpace.home);
      expect(utility.spaceId, homeSpace!.id);
      expect(await repository.watchUtilities().first, hasLength(1));
    });

    test('a utility whose bill was deleted is excluded', () async {
      final bill = await electricity();
      await repository.addUtility(
        NewHomeUtility(name: 'Electricity', iconKey: 'bolt', billId: bill.id),
      );
      await bills.softDelete(bill.id);

      expect(await repository.watchUtilities().first, isEmpty);
    });

    test('removing a utility leaves the bill untouched', () async {
      final bill = await electricity();
      final utility = await repository.addUtility(
        NewHomeUtility(name: 'Electricity', iconKey: 'bolt', billId: bill.id),
      );

      await repository.removeUtility(utility.id);

      expect(await repository.watchUtilities().first, isEmpty);
      expect(await bills.findById(bill.id), isNotNull);
    });
  });

  group('maintenance jobs', () {
    test('stores the job in the Home system space', () async {
      final job = await repository.createJob(
        const NewMaintenanceJob(title: 'AC service'),
      );

      final homeSpace = await spaces.findBySystemKey(SystemSpace.home);
      expect(job.spaceId, homeSpace!.id);
      expect(job.status, MaintenanceJobStatus.upcoming);
    });

    test('edit changes only what it is given', () async {
      final job = await repository.createJob(
        const NewMaintenanceJob(title: 'AC service', costMinor: 500000),
      );

      final edited = await repository.editJob(job.id, vendor: 'CoolCare');

      expect(edited.title, 'AC service');
      expect(edited.costMinor, 500000);
      expect(edited.vendor, 'CoolCare');
    });

    test('clearing a field needs the sentinel', () async {
      final job = await repository.createJob(
        const NewMaintenanceJob(title: 'AC service', vendor: 'CoolCare'),
      );

      final untouched = await repository.editJob(job.id, title: 'AC service');
      expect(untouched.vendor, 'CoolCare');

      final cleared = await repository.editJob(job.id, clearVendor: true);
      expect(cleared.vendor, isNull);
    });

    test('needing attention is the Overdue display status only', () async {
      final overdue = await repository.createJob(
        NewMaintenanceJob(title: 'Society maintenance', dueDate: DateTime(2026, 8, 1)),
      );
      await repository.createJob(
        NewMaintenanceJob(title: 'AC service', dueDate: DateTime(2026, 9, 20)),
      );
      // Active despite a past date: never overdue.
      final active = await repository.createJob(
        const NewMaintenanceJob(title: 'Kitchen tap leak'),
      );
      await repository.editJob(
        active.id,
        status: MaintenanceJobStatus.active,
        dueDate: DateTime(2026, 8, 1),
      );

      final urgent = await repository
          .watchJobsNeedingAttention(today: testToday)
          .first;
      expect(urgent.map((j) => j.id), [overdue.id]);
    });

    test('soft delete hides it, restore brings it back', () async {
      final job = await repository.createJob(
        const NewMaintenanceJob(title: 'AC service'),
      );

      await repository.softDeleteJob(job.id);
      expect(await repository.watchJobs().first, isEmpty);

      await repository.restoreJob(job.id);
      expect((await repository.watchJobs().first).single.id, job.id);
    });
  });

  group('appliances', () {
    test('stores the appliance in the Home system space and schedules a reminder',
        () async {
      final appliance = await repository.createAppliance(
        NewAppliance(name: 'Refrigerator', warrantyTill: DateTime(2026, 12, 15)),
      );

      final homeSpace = await spaces.findBySystemKey(SystemSpace.home);
      expect(appliance.spaceId, homeSpace!.id);
      expect(
        scheduler.latestFor(appliance.id)!.fireAt,
        DateTime(2026, 11, 15, applianceReminderHour),
      );
    });

    test('an appliance with no warranty schedules nothing', () async {
      final appliance = await repository.createAppliance(
        const NewAppliance(name: 'Inverter battery'),
      );

      expect(scheduler.latestFor(appliance.id), isNull);
      expect(scheduler.cancelled, contains(appliance.id));
    });

    test('clearing the warranty needs the sentinel, and cancels the reminder',
        () async {
      final appliance = await repository.createAppliance(
        NewAppliance(name: 'Refrigerator', warrantyTill: DateTime(2026, 12, 15)),
      );
      scheduler.clear();

      final edited = await repository.editAppliance(
        appliance.id,
        clearWarrantyTill: true,
      );

      expect(edited.warrantyTill, isNull);
      expect(scheduler.cancelled, contains(appliance.id));
    });

    test('needing attention is expiring-or-expired within the fixed lead time',
        () async {
      final expiring = await repository.createAppliance(
        NewAppliance(name: 'Water purifier', warrantyTill: DateTime(2026, 9, 19)),
      );
      await repository.createAppliance(
        NewAppliance(name: 'Washing machine', warrantyTill: DateTime(2027, 8, 1)),
      );

      final urgent = await repository
          .watchAppliancesNeedingAttention(today: testToday)
          .first;
      expect(urgent.map((a) => a.id), [expiring.id]);
    });

    test('soft delete cancels the reminder; restore re-syncs it', () async {
      final appliance = await repository.createAppliance(
        NewAppliance(name: 'Refrigerator', warrantyTill: DateTime(2026, 12, 15)),
      );
      scheduler.clear();

      await repository.softDeleteAppliance(appliance.id);
      expect(await repository.watchAppliances().first, isEmpty);
      expect(scheduler.cancelled, contains(appliance.id));

      await repository.restoreAppliance(appliance.id);
      expect((await repository.watchAppliances().first).single.id, appliance.id);
      expect(scheduler.latestFor(appliance.id), isNotNull);
    });
  });
}
