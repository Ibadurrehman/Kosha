import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/services/notifications/scheduled_reminder.dart';
import 'package:kosha/features/bills/domain/bill_reminder.dart';
import 'package:kosha/features/bills/domain/entities/bill.dart';

void main() {
  final createdAt = DateTime(2026, 1, 1);

  Bill bill({
    DateTime? nextDue,
    int reminderOffsetDays = 3,
    BillKind kind = BillKind.bill,
    int amountMinor = 185000,
  }) =>
      Bill(
        id: 'b1',
        name: 'Electricity',
        amountMinor: amountMinor,
        kind: kind,
        nextDue: nextDue,
        reminderOffsetDays: reminderOffsetDays,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

  group('intendedBillFireAt', () {
    test('is the lead time before the due date, at 9 am', () {
      expect(
        intendedBillFireAt(bill(nextDue: DateTime(2026, 9, 10))),
        DateTime(2026, 9, 7, 9),
      );
    });

    test('a zero lead fires on the day itself', () {
      expect(
        intendedBillFireAt(
          bill(nextDue: DateTime(2026, 9, 10), reminderOffsetDays: 0),
        ),
        DateTime(2026, 9, 10, 9),
      );
    });

    test('crossing a month boundary lands in the previous month', () {
      expect(
        intendedBillFireAt(
          bill(nextDue: DateTime(2026, 3, 2), reminderOffsetDays: 7),
        ),
        DateTime(2026, 2, 23, 9),
      );
    });

    test('is null when nothing is owed', () {
      expect(intendedBillFireAt(bill()), isNull);
    });

    test('reports the moment even after it has passed', () {
      // This is the whole point of the split from reminderForBill: the
      // notification inbox reconciles exactly the fire moments in the past.
      expect(
        intendedBillFireAt(bill(nextDue: DateTime(2020, 1, 10))),
        DateTime(2020, 1, 7, 9),
      );
    });
  });

  group('reminderForBill', () {
    test('describes what the OS should show', () {
      final reminder = reminderForBill(
        bill(nextDue: DateTime(2026, 9, 10)),
        now: DateTime(2026, 9, 4, 9, 41),
      );
      expect(reminder, isNotNull);
      expect(reminder!.kind, ReminderKind.bill);
      expect(reminder.ownerId, 'b1');
      expect(reminder.title, 'Electricity');
      expect(reminder.body, '₹1,850 · due in 3 days');
      expect(reminder.fireAt, DateTime(2026, 9, 7, 9));
      expect(reminder.route, '/home/finance/bills/b1');
    });

    test('is null once the moment has passed', () {
      expect(
        reminderForBill(
          bill(nextDue: DateTime(2026, 9, 10)),
          now: DateTime(2026, 9, 8, 9, 41),
        ),
        isNull,
      );
    });

    test('is null when nothing is owed', () {
      expect(reminderForBill(bill(), now: DateTime(2026, 9, 4)), isNull);
    });
  });

  group('billReminderBody', () {
    test('a subscription renews rather than falls due', () {
      expect(
        billReminderBody(
          bill(
            nextDue: DateTime(2026, 9, 15),
            kind: BillKind.subscription,
            amountMinor: 64900,
            reminderOffsetDays: 1,
          ),
        ),
        '₹649 · renews tomorrow',
      );
    });

    test('a zero lead reads as today', () {
      expect(
        billReminderBody(
          bill(nextDue: DateTime(2026, 9, 10), reminderOffsetDays: 0),
        ),
        '₹1,850 · due today',
      );
    });
  });
}
