import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/features/bills/domain/entities/bill.dart';

void main() {
  final today = DateTime(2026, 9, 4);
  final createdAt = DateTime(2026, 1, 1);

  Bill bill({
    DateTime? nextDue,
    DateTime? lastPaidOn,
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
        lastPaidOn: lastPaidOn,
        reminderOffsetDays: reminderOffsetDays,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

  group('billStatus', () {
    test('a due date in the past is overdue', () {
      expect(
        billStatus(bill(nextDue: DateTime(2026, 9, 1)), today),
        BillStatus.overdue,
      );
    });

    test('due today is due soon, not overdue', () {
      expect(billStatus(bill(nextDue: today), today), BillStatus.dueSoon);
    });

    test('inside the reminder window is due soon; the day after is upcoming', () {
      expect(
        billStatus(bill(nextDue: DateTime(2026, 9, 7)), today),
        BillStatus.dueSoon,
      );
      expect(
        billStatus(bill(nextDue: DateTime(2026, 9, 8)), today),
        BillStatus.upcoming,
      );
    });

    test('the window follows the bill\'s own lead time', () {
      final longLead = bill(nextDue: DateTime(2026, 9, 15), reminderOffsetDays: 14);
      expect(billStatus(longLead, today), BillStatus.dueSoon);
    });

    test('a paid bill whose next cycle is still far off reads as paid', () {
      final paid = bill(
        nextDue: DateTime(2026, 10, 10),
        lastPaidOn: DateTime(2026, 9, 2),
      );
      expect(billStatus(paid, today), BillStatus.paid);
    });

    test('a previous payment does not hide the next cycle coming due', () {
      // Paid in September, but the October bill is now inside its own
      // reminder window: it is due again, not resting on the old payment.
      final paid = bill(
        nextDue: DateTime(2026, 9, 6),
        lastPaidOn: DateTime(2026, 8, 8),
      );
      expect(billStatus(paid, today), BillStatus.dueSoon);
    });

    test('a previous payment does not hide an overdue cycle either', () {
      final paid = bill(
        nextDue: DateTime(2026, 8, 10),
        lastPaidOn: DateTime(2026, 7, 8),
      );
      expect(billStatus(paid, today), BillStatus.overdue);
    });

    test('a one-off with no date left owes nothing', () {
      expect(
        billStatus(bill(lastPaidOn: DateTime(2026, 8, 28)), today),
        BillStatus.paid,
      );
    });

    test('an unpaid bill far out is upcoming, not paid', () {
      expect(
        billStatus(bill(nextDue: DateTime(2026, 12, 1)), today),
        BillStatus.upcoming,
      );
    });
  });

  group('billMatchesTab', () {
    test('All shows every status', () {
      for (final status in BillStatus.values) {
        expect(billMatchesTab(status, BillTab.all), isTrue);
      }
    });

    test('each other tab shows exactly its own status', () {
      expect(billMatchesTab(BillStatus.overdue, BillTab.overdue), isTrue);
      expect(billMatchesTab(BillStatus.overdue, BillTab.dueSoon), isFalse);
      expect(billMatchesTab(BillStatus.paid, BillTab.paid), isTrue);
      expect(billMatchesTab(BillStatus.upcoming, BillTab.paid), isFalse);
    });
  });

  group('outstandingMinor', () {
    test('adds up everything not yet paid', () {
      final bills = [
        bill(nextDue: DateTime(2026, 9, 1), amountMinor: 240000),
        bill(nextDue: DateTime(2026, 9, 10), amountMinor: 99900),
        // Paid: contributes nothing.
        bill(
          nextDue: DateTime(2026, 10, 15),
          lastPaidOn: DateTime(2026, 9, 2),
          amountMinor: 64900,
        ),
      ];
      expect(outstandingMinor(bills, today), 339900);
    });

    test('is zero when everything is settled', () {
      expect(outstandingMinor([bill(lastPaidOn: today)], today), 0);
    });
  });
}
