import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/clock.dart';
import '../../data/bill_repository_impl.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/payment.dart';

part 'bill_providers.g.dart';

/// How far ahead Finance's "Upcoming bills" card looks.
const int upcomingBillsWindowDays = 14;

/// How many bills that card lists before it stops and defers to the Bills
/// screen.
const int upcomingBillsPreviewCount = 3;

@riverpod
Stream<List<Bill>> allBills(Ref ref) => ref.watch(billRepositoryProvider).watchAll();

/// One bill for the detail screen; emits null once it is deleted.
@riverpod
Stream<Bill?> billById(Ref ref, String id) =>
    ref.watch(billRepositoryProvider).watchById(id);

@riverpod
Stream<List<Payment>> billPayments(Ref ref, String id) =>
    ref.watch(billRepositoryProvider).watchPayments(id);

/// The Bills-screen tab. Kept alive so it survives leaving the screen, like
/// the Tasks screen's own tab state.
@Riverpod(keepAlive: true)
class SelectedBillTab extends _$SelectedBillTab {
  @override
  BillTab build() => BillTab.all;

  void select(BillTab tab) => state = tab;
}

/// The bills one tab shows, ordered the way each tab reads best: soonest
/// first everywhere except Paid, which is most-recently-paid first.
///
/// The filtering happens in Dart, not SQL, because bill status is derived
/// from `nextDue` against today and never stored (section 5.2) — a WHERE
/// clause would have to re-implement [billStatus] and could drift from it.
@riverpod
Stream<List<Bill>> billsInTab(Ref ref, BillTab tab) {
  final today = ref.watch(clockProvider).today();
  return ref.watch(billRepositoryProvider).watchAll().map((bills) {
    final matching = [
      for (final bill in bills)
        if (billMatchesTab(billStatus(bill, today), tab)) bill,
    ];
    if (tab == BillTab.paid) {
      matching.sort((a, b) {
        final left = a.lastPaidOn;
        final right = b.lastPaidOn;
        if (left == null && right == null) return a.name.compareTo(b.name);
        if (left == null) return 1;
        if (right == null) return -1;
        return right.compareTo(left);
      });
    }
    return matching;
  });
}

/// Everything still owed across every bill — the Bills screen's header total.
@riverpod
Stream<int> outstandingBillsMinor(Ref ref) {
  final today = ref.watch(clockProvider).today();
  return ref
      .watch(billRepositoryProvider)
      .watchAll()
      .map((bills) => outstandingMinor(bills, today));
}

/// What the Finance dashboard's "Upcoming bills" card needs: everything owed
/// in the near term, soonest first, plus the total across all of it.
class UpcomingBills {
  const UpcomingBills({required this.bills, required this.totalMinor});

  static const UpcomingBills empty = UpcomingBills(bills: [], totalMinor: 0);

  /// Overdue and near-term bills, soonest first.
  final List<Bill> bills;

  /// Everything in [bills] added up — the figure on the card.
  final int totalMinor;

  int get count => bills.length;
}

/// Overdue bills plus everything falling due inside
/// [upcomingBillsWindowDays]. Paid bills never appear: paying is exactly what
/// should make a bill leave this card.
@riverpod
Stream<UpcomingBills> upcomingBills(Ref ref) {
  final today = ref.watch(clockProvider).today();
  final horizon = DateTime(
    today.year,
    today.month,
    today.day + upcomingBillsWindowDays,
  );
  return ref.watch(billRepositoryProvider).watchAll().map((bills) {
    final due = [
      for (final bill in bills)
        if (bill.nextDue != null &&
            !bill.nextDue!.isAfter(horizon) &&
            billStatus(bill, today) != BillStatus.paid)
          bill,
    ]..sort((a, b) => a.nextDue!.compareTo(b.nextDue!));
    return UpcomingBills(
      bills: due,
      totalMinor: due.fold<int>(0, (sum, bill) => sum + bill.amountMinor),
    );
  });
}
