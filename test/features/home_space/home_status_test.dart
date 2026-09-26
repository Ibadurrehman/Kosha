import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/features/home_space/domain/entities/appliance.dart';
import 'package:kosha/features/home_space/domain/entities/maintenance_job.dart';

import '../../helpers/test_app.dart';

void main() {
  MaintenanceJob job({
    MaintenanceJobStatus status = MaintenanceJobStatus.upcoming,
    DateTime? dueDate,
  }) =>
      MaintenanceJob(
        id: 'j1',
        title: 'AC service',
        status: status,
        dueDate: dueDate,
        spaceId: 's1',
        createdAt: testNow,
        updatedAt: testNow,
      );

  group('maintenanceJobDisplayStatus', () {
    test('an Upcoming job with a future date stays Upcoming', () {
      final status = maintenanceJobDisplayStatus(
        job(dueDate: DateTime(2026, 9, 10)),
        testToday,
      );
      expect(status, MaintenanceJobStatus.upcoming);
    });

    test('an Upcoming job with a past date reads as Overdue', () {
      final status = maintenanceJobDisplayStatus(
        job(dueDate: DateTime(2026, 8, 1)),
        testToday,
      );
      expect(status, MaintenanceJobStatus.overdue);
    });

    test('an Upcoming job with no date at all can never be Overdue', () {
      final status = maintenanceJobDisplayStatus(job(), testToday);
      expect(status, MaintenanceJobStatus.upcoming);
    });

    test('Active overrides a past date — the seed\'s "Kitchen tap leak" shape',
        () {
      final status = maintenanceJobDisplayStatus(
        job(status: MaintenanceJobStatus.active, dueDate: DateTime(2026, 8, 1)),
        testToday,
      );
      expect(status, MaintenanceJobStatus.active);
    });

    test('Done overrides a past date', () {
      final status = maintenanceJobDisplayStatus(
        job(status: MaintenanceJobStatus.done, dueDate: DateTime(2026, 8, 1)),
        testToday,
      );
      expect(status, MaintenanceJobStatus.done);
    });
  });

  group('maintenanceJobNeedsAttention', () {
    test('only the derived Overdue status needs attention', () {
      expect(
        maintenanceJobNeedsAttention(MaintenanceJobStatus.overdue),
        isTrue,
      );
      expect(
        maintenanceJobNeedsAttention(MaintenanceJobStatus.upcoming),
        isFalse,
      );
      expect(
        maintenanceJobNeedsAttention(MaintenanceJobStatus.active),
        isFalse,
      );
      expect(maintenanceJobNeedsAttention(MaintenanceJobStatus.done), isFalse);
    });
  });

  Appliance appliance({DateTime? warrantyTill}) => Appliance(
        id: 'a1',
        name: 'Refrigerator',
        warrantyTill: warrantyTill,
        spaceId: 's1',
        createdAt: testNow,
        updatedAt: testNow,
      );

  group('applianceWarrantyStatus', () {
    test('no warranty date is its own state, not Valid', () {
      expect(
        applianceWarrantyStatus(appliance(), testToday),
        ApplianceWarrantyStatus.noWarranty,
      );
    });

    test('a warranty comfortably ahead is Valid', () {
      final status = applianceWarrantyStatus(
        appliance(warrantyTill: DateTime(2028, 3, 1)),
        testToday,
      );
      expect(status, ApplianceWarrantyStatus.valid);
    });

    test('inside the fixed 30-day lead time it is Expiring', () {
      final status = applianceWarrantyStatus(
        appliance(warrantyTill: DateTime(2026, 9, 19)),
        testToday,
      );
      expect(status, ApplianceWarrantyStatus.expiring);
    });

    test('a warranty that has lapsed is Expired', () {
      final status = applianceWarrantyStatus(
        appliance(warrantyTill: DateTime(2026, 8, 30)),
        testToday,
      );
      expect(status, ApplianceWarrantyStatus.expired);
    });
  });

  group('applianceNeedsAttention', () {
    test('expired and expiring need attention; valid and noWarranty do not',
        () {
      expect(
        applianceNeedsAttention(ApplianceWarrantyStatus.expired),
        isTrue,
      );
      expect(
        applianceNeedsAttention(ApplianceWarrantyStatus.expiring),
        isTrue,
      );
      expect(applianceNeedsAttention(ApplianceWarrantyStatus.valid), isFalse);
      expect(
        applianceNeedsAttention(ApplianceWarrantyStatus.noWarranty),
        isFalse,
      );
    });
  });
}
