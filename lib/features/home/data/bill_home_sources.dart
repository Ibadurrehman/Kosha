import '../../../core/utils/formatters.dart';
import '../../bills/domain/bill_repository.dart';
import '../../bills/domain/entities/bill.dart';
import '../domain/entities/home_item_kind.dart';
import '../domain/entities/needs_attention_item.dart';
import '../domain/entities/recent_item.dart';
import '../domain/entities/upcoming_item.dart';
import '../domain/needs_attention_source.dart';
import '../domain/recent_source.dart';
import '../domain/upcoming_source.dart';

/// Bills' contributions to Home's three aggregated sections.
///
/// These are pure additions alongside the Tasks adapters — Home's providers
/// merge them, nothing about the existing sources changed (plan §12.1.3).
/// Overdue bills say "Pay" rather than "View", which is what the
/// `ctaLabel` field on [NeedsAttentionItem] was put there for.
class BillNeedsAttentionSource implements NeedsAttentionSource {
  BillNeedsAttentionSource(this._bills);

  final BillRepository _bills;

  @override
  Stream<List<NeedsAttentionItem>> watch({required DateTime today}) {
    return _bills.watchOverdue(today: today).map(
          (bills) => [
            for (final bill in bills)
              NeedsAttentionItem(
                id: bill.id,
                kind: HomeItemKind.bill,
                title: bill.name,
                subtitle:
                    '${Money.inr(bill.amountMinor)} · ${_overdueBy(bill, today)}',
                ctaLabel: 'Pay',
              ),
          ],
        );
  }

  String _overdueBy(Bill bill, DateTime today) {
    final due = bill.nextDue;
    if (due == null) return 'Overdue';
    final days = today.difference(due).inDays;
    return days <= 1 ? 'Overdue since yesterday' : 'Overdue by $days days';
  }
}

/// Bills falling due inside Home's window.
class BillUpcomingSource implements UpcomingSource {
  BillUpcomingSource(this._bills);

  final BillRepository _bills;

  @override
  Stream<List<UpcomingItem>> watch({
    required DateTime from,
    required DateTime to,
  }) {
    return _bills.watchDueBetween(from, to).map(
          (bills) => [
            for (final bill in bills)
              UpcomingItem(
                id: bill.id,
                kind: HomeItemKind.bill,
                title: bill.name,
                date: bill.nextDue!,
              ),
          ],
        );
  }
}

/// Recently added or paid bills. A payment bumps `updatedAt`, so settling one
/// surfaces here the same way editing it would.
class BillRecentSource implements RecentSource {
  BillRecentSource(this._bills);

  final BillRepository _bills;

  @override
  Stream<List<RecentItem>> watch({required int limit}) {
    return _bills.watchRecent(limit: limit).map(
          (bills) => [
            for (final bill in bills)
              RecentItem(
                id: bill.id,
                kind: HomeItemKind.bill,
                title: bill.name,
                subtitle: _subtitle(bill),
                at: bill.updatedAt,
              ),
          ],
        );
  }

  String _subtitle(Bill bill) {
    final due = bill.nextDue;
    if (due == null) {
      final paid = bill.lastPaidOn;
      return paid == null ? 'No date' : 'Paid ${Dates.dayMonth(paid)}';
    }
    return 'Due ${Dates.dayMonth(due)}';
  }
}
