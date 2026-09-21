import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/bills/data/bill_repository_impl.dart';
import 'package:kosha/features/bills/domain/entities/bill.dart';
import 'package:kosha/features/home/data/bill_home_sources.dart';
import 'package:kosha/features/home/domain/entities/home_item_kind.dart';
import 'package:kosha/features/home/presentation/home_item_routing.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DriftBillRepository bills;

  setUp(() {
    db = testDatabase();
    bills = testBillRepository(db);
  });

  tearDown(() => db.close());

  Future<Bill> add({
    required String name,
    required DateTime nextDue,
    int amountMinor = 240000,
  }) =>
      bills.create(
        NewBill(
          name: name,
          amountMinor: amountMinor,
          nextDue: nextDue,
          frequencyRule: 'FREQ=MONTHLY',
        ),
      );

  group('needs attention', () {
    test('an overdue bill says how much and how late, with a "Pay" CTA',
        () async {
      await add(name: 'Society maintenance', nextDue: DateTime(2026, 9, 1));

      final items =
          await BillNeedsAttentionSource(bills).watch(today: testToday).first;

      expect(items, hasLength(1));
      expect(items.single.kind, HomeItemKind.bill);
      expect(items.single.title, 'Society maintenance');
      expect(items.single.subtitle, '₹2,400 · Overdue by 3 days');
      expect(items.single.ctaLabel, 'Pay');
    });

    test('paying it clears the row', () async {
      final bill =
          await add(name: 'Society maintenance', nextDue: DateTime(2026, 9, 1));
      await bills.markPaid(bill.id);

      final items =
          await BillNeedsAttentionSource(bills).watch(today: testToday).first;
      expect(items, isEmpty);
    });

    test('a bill that is not yet due does not appear', () async {
      await add(name: 'Electricity', nextDue: DateTime(2026, 9, 10));
      final items =
          await BillNeedsAttentionSource(bills).watch(today: testToday).first;
      expect(items, isEmpty);
    });
  });

  group('upcoming', () {
    test('lists bills falling due inside the window', () async {
      await add(name: 'Electricity', nextDue: DateTime(2026, 9, 10));
      await add(name: 'Far off', nextDue: DateTime(2026, 12, 1));

      final items = await BillUpcomingSource(bills)
          .watch(from: DateTime(2026, 9, 5), to: DateTime(2026, 9, 12))
          .first;

      expect(items.map((i) => i.title), ['Electricity']);
      expect(items.single.date, DateTime(2026, 9, 10));
    });
  });

  group('recent', () {
    test('a payment bumps the bill to the top of Recent', () async {
      final electricity =
          await add(name: 'Electricity', nextDue: DateTime(2026, 9, 10));
      await add(name: 'Internet', nextDue: DateTime(2026, 9, 18));

      final later = testBillRepository(
        db,
        now: testNow.add(const Duration(days: 1)),
      );
      await later.markPaid(electricity.id);

      final items = await BillRecentSource(bills).watch(limit: 10).first;
      expect(items.first.title, 'Electricity');
      expect(items.first.subtitle, 'Due 10 Oct');
    });

    test('a settled one-off reads as paid rather than dateless', () async {
      final gas = await bills.create(
        const NewBill(name: 'Gas cylinder', amountMinor: 110500),
      );
      await bills.markPaid(gas.id, paidOn: DateTime(2026, 8, 28));

      final items = await BillRecentSource(bills).watch(limit: 10).first;
      expect(items.single.subtitle, 'Paid 28 Aug');
    });
  });

  test('a bill item routes to its own detail screen', () {
    expect(homeItemRoute(HomeItemKind.bill, 'b1'), '/home/finance/bills/b1');
  });
}
