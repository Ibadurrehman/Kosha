import 'package:freezed_annotation/freezed_annotation.dart';

import 'entities/settlement.dart';
import 'entities/shared_expense.dart';

part 'ledger.freezed.dart';

/// One member's standing: what they put in, minus what was theirs to pay.
@freezed
abstract class LedgerBalance with _$LedgerBalance {
  const factory LedgerBalance({
    required String memberId,

    /// Positive when the group owes them, negative when they owe the group.
    required int netMinor,
    required int paidMinor,
    required int shareMinor,
  }) = _LedgerBalance;

  const LedgerBalance._();

  bool get isOwed => netMinor > 0;

  bool get owes => netMinor < 0;

  bool get isSquare => netMinor == 0;
}

/// One payment the settle-up screen suggests.
@freezed
abstract class Transfer with _$Transfer {
  const factory Transfer({
    required String fromMemberId,
    required String toMemberId,
    required int amountMinor,
  }) = _Transfer;

  const Transfer._();
}

/// Where everyone stands, and the shortest list of payments that squares it.
@freezed
abstract class Ledger with _$Ledger {
  const factory Ledger({
    required List<LedgerBalance> balances,
    required List<Transfer> transfers,
    required int totalMinor,
  }) = _Ledger;

  const Ledger._();

  /// "Everyone's square" — §6.14's empty state.
  bool get isSquare => transfers.isEmpty;

  LedgerBalance? balanceFor(String memberId) {
    for (final balance in balances) {
      if (balance.memberId == memberId) return balance;
    }
    return null;
  }
}

/// The prototype's `ledger()`, ported (§6.14's acceptance criterion).
///
/// Net per member is what they paid minus their share, then settlements move
/// the line: paying somebody back raises the payer's net and lowers the
/// receiver's, because the debt it clears was already counted in the shares.
///
/// **Members are walked in the order given, not by size of debt.** §6.14 calls
/// this "greedy netting (largest debtor pays largest creditor)", but the
/// prototype's own `ledger()` filters `ALL` in declaration order and never
/// sorts, and Appendix B's expected transfers are the ones that order
/// produces — Meera→You ₹3,800, Rohan→You ₹4,600, Rohan→Aarav ₹1,000, where
/// sorting by size would give Rohan→You ₹5,600, Meera→You ₹2,800,
/// Meera→Aarav ₹1,000. Both are three transfers and both settle everyone
/// exactly; the plan's prose is the odd one out, so the prototype and the
/// documented numbers win. Note that sorting by size would not even be a
/// general improvement: minimising the number of transfers is NP-hard, and
/// neither order promises the true minimum.
///
/// Amounts are exact integers throughout. The prototype needed a ₹1 threshold
/// to stop floating-point dust showing up as a settlement; materialised
/// shares (see [ExpenseShare]) make the nets whole minor units that sum to
/// zero, so every last paisa can be settled and none is invented.
Ledger buildLedger({
  required List<String> memberIds,
  required List<SharedExpense> expenses,
  required List<ExpenseShare> shares,
  required List<Settlement> settlements,
}) {
  final paid = <String, int>{for (final id in memberIds) id: 0};
  final owed = <String, int>{for (final id in memberIds) id: 0};
  var total = 0;

  for (final expense in expenses) {
    if (expense.isDeleted) continue;
    total += expense.amountMinor;
    final payer = expense.paidByMemberId;
    if (paid.containsKey(payer)) {
      paid[payer] = paid[payer]! + expense.amountMinor;
    }
  }

  // Shares of an expense that is gone (or of somebody no longer in the group)
  // are skipped, so a deleted expense leaves no trace in anybody's balance.
  final liveExpenseIds = {
    for (final expense in expenses)
      if (!expense.isDeleted) expense.id,
  };
  for (final share in shares) {
    if (!liveExpenseIds.contains(share.sharedExpenseId)) continue;
    if (!owed.containsKey(share.memberId)) continue;
    owed[share.memberId] = owed[share.memberId]! + share.amountMinor;
  }

  final net = <String, int>{
    for (final id in memberIds) id: paid[id]! - owed[id]!,
  };

  for (final settlement in settlements) {
    if (settlement.isDeleted) continue;
    final from = settlement.fromMemberId;
    final to = settlement.toMemberId;
    if (net.containsKey(from)) {
      net[from] = net[from]! + settlement.amountMinor;
    }
    if (net.containsKey(to)) {
      net[to] = net[to]! - settlement.amountMinor;
    }
  }

  final balances = [
    for (final id in memberIds)
      LedgerBalance(
        memberId: id,
        netMinor: net[id]!,
        paidMinor: paid[id]!,
        shareMinor: owed[id]!,
      ),
  ];

  return Ledger(
    balances: balances,
    transfers: _settle(memberIds, net),
    totalMinor: total,
  );
}

/// Two pointers over debtors and creditors, both in member order, each
/// transfer as large as the smaller of the two sides — the prototype's own
/// `while (i < a.length && j < b.length)` loop.
List<Transfer> _settle(List<String> memberIds, Map<String, int> net) {
  final debtors = [
    for (final id in memberIds)
      if (net[id]! < 0) (id: id, amount: -net[id]!),
  ];
  final creditors = [
    for (final id in memberIds)
      if (net[id]! > 0) (id: id, amount: net[id]!),
  ];

  final transfers = <Transfer>[];
  var i = 0;
  var j = 0;
  var debt = debtors.isEmpty ? 0 : debtors.first.amount;
  var credit = creditors.isEmpty ? 0 : creditors.first.amount;

  while (i < debtors.length && j < creditors.length) {
    final amount = debt < credit ? debt : credit;
    transfers.add(
      Transfer(
        fromMemberId: debtors[i].id,
        toMemberId: creditors[j].id,
        amountMinor: amount,
      ),
    );
    debt -= amount;
    credit -= amount;
    if (debt == 0) {
      i++;
      if (i < debtors.length) debt = debtors[i].amount;
    }
    if (credit == 0) {
      j++;
      if (j < creditors.length) credit = creditors[j].amount;
    }
  }
  return transfers;
}
