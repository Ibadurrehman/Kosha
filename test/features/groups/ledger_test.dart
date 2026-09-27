import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/features/groups/domain/entities/settlement.dart';
import 'package:kosha/features/groups/domain/entities/shared_expense.dart';
import 'package:kosha/features/groups/domain/ledger.dart';

import '../../helpers/test_app.dart';

/// Section 6.14's acceptance criterion: the prototype's `ledger()` ported as a
/// pure function, tested against its own seed data, expecting 3 transfers.
void main() {
  // Appendix B's Goa trip, in the prototype's own member order.
  const you = 'you';
  const aarav = 'aarav';
  const meera = 'meera';
  const rohan = 'rohan';
  const everyone = [you, aarav, meera, rohan];

  var nextId = 0;

  /// One expense plus its materialised shares, the way the repository stores
  /// them.
  (SharedExpense, List<ExpenseShare>) expense({
    required String label,
    required int rupees,
    required String paidBy,
    List<String>? people,
  }) {
    final id = 'e${nextId++}';
    final among = people ?? everyone;
    final shares = splitEqually(rupees * 100, among);
    return (
      SharedExpense(
        id: id,
        groupId: 'g1',
        label: label,
        amountMinor: rupees * 100,
        paidByMemberId: paidBy,
        date: testNow,
        createdAt: testNow,
        updatedAt: testNow,
      ),
      [
        for (final entry in shares.entries)
          ExpenseShare(
            id: '$id-${entry.key}',
            sharedExpenseId: id,
            memberId: entry.key,
            amountMinor: entry.value,
          ),
      ],
    );
  }

  Ledger goaTrip({List<Settlement> settlements = const []}) {
    nextId = 0;
    final entries = [
      expense(label: 'Flights — IndiGo 6E-573', rupees: 11600, paidBy: you),
      expense(label: 'Hotel deposit', rupees: 6000, paidBy: aarav),
      expense(
        label: 'Scooter rental',
        rupees: 1800,
        paidBy: meera,
        people: const [you, meera, rohan],
      ),
      expense(label: 'Dinner at Gunpowder', rupees: 2400, paidBy: you),
    ];
    return buildLedger(
      memberIds: everyone,
      expenses: [for (final (e, _) in entries) e],
      shares: [for (final (_, s) in entries) ...s],
      settlements: settlements,
    );
  }

  group("the prototype's seed trip", () {
    test('nets match Appendix B exactly', () {
      final ledger = goaTrip();

      expect(ledger.balanceFor(you)!.netMinor, 8400 * 100);
      expect(ledger.balanceFor(aarav)!.netMinor, 1000 * 100);
      expect(ledger.balanceFor(meera)!.netMinor, -3800 * 100);
      expect(ledger.balanceFor(rohan)!.netMinor, -5600 * 100);
    });

    test('settles in exactly 3 transfers', () {
      expect(goaTrip().transfers, hasLength(3));
    });

    test('the transfers are the ones Appendix B names', () {
      expect(
        goaTrip().transfers,
        [
          const Transfer(
            fromMemberId: meera,
            toMemberId: you,
            amountMinor: 3800 * 100,
          ),
          const Transfer(
            fromMemberId: rohan,
            toMemberId: you,
            amountMinor: 4600 * 100,
          ),
          const Transfer(
            fromMemberId: rohan,
            toMemberId: aarav,
            amountMinor: 1000 * 100,
          ),
        ],
      );
    });

    test('the group total is what was actually spent', () {
      expect(goaTrip().totalMinor, (11600 + 6000 + 1800 + 2400) * 100);
    });

    test('paid and share are reported per member, not just the net', () {
      final ledger = goaTrip();

      expect(ledger.balanceFor(you)!.paidMinor, 14000 * 100);
      expect(ledger.balanceFor(you)!.shareMinor, 5600 * 100);
      expect(
        ledger.balanceFor(rohan)!.paidMinor,
        0,
        reason: 'Rohan paid for nothing and owes his share of everything',
      );
      expect(ledger.balanceFor(rohan)!.shareMinor, 5600 * 100);
    });

    test('every net sums to zero, so nothing is invented or lost', () {
      final total = goaTrip()
          .balances
          .fold<int>(0, (sum, balance) => sum + balance.netMinor);
      expect(total, 0);
    });

    test('the transfers settle everybody exactly', () {
      final ledger = goaTrip();
      final moved = <String, int>{for (final id in everyone) id: 0};
      for (final transfer in ledger.transfers) {
        moved[transfer.fromMemberId] =
            moved[transfer.fromMemberId]! + transfer.amountMinor;
        moved[transfer.toMemberId] =
            moved[transfer.toMemberId]! - transfer.amountMinor;
      }
      for (final balance in ledger.balances) {
        expect(
          balance.netMinor + moved[balance.memberId]!,
          0,
          reason: '${balance.memberId} is left holding something',
        );
      }
    });
  });

  group('settlements', () {
    test('paying one transfer off leaves the other two', () {
      final first = goaTrip().transfers.first;
      final ledger = goaTrip(
        settlements: [
          Settlement(
            id: 's1',
            groupId: 'g1',
            fromMemberId: first.fromMemberId,
            toMemberId: first.toMemberId,
            amountMinor: first.amountMinor,
            recordedAt: testNow,
            createdAt: testNow,
          ),
        ],
      );

      expect(ledger.transfers, hasLength(2));
      expect(ledger.balanceFor(meera)!.isSquare, isTrue);
    });

    test('paying everything off leaves everyone square', () {
      final ledger = goaTrip(
        settlements: [
          for (final (index, transfer) in goaTrip().transfers.indexed)
            Settlement(
              id: 's$index',
              groupId: 'g1',
              fromMemberId: transfer.fromMemberId,
              toMemberId: transfer.toMemberId,
              amountMinor: transfer.amountMinor,
              recordedAt: testNow,
              createdAt: testNow,
            ),
        ],
      );

      expect(ledger.isSquare, isTrue);
      expect(ledger.balances.every((b) => b.isSquare), isTrue);
    });

    test('a deleted settlement stops counting', () {
      final first = goaTrip().transfers.first;
      final ledger = goaTrip(
        settlements: [
          Settlement(
            id: 's1',
            groupId: 'g1',
            fromMemberId: first.fromMemberId,
            toMemberId: first.toMemberId,
            amountMinor: first.amountMinor,
            recordedAt: testNow,
            createdAt: testNow,
            deletedAt: testNow,
          ),
        ],
      );

      expect(ledger.transfers, hasLength(3));
    });

    test('overpaying flips the direction rather than going negative', () {
      final ledger = buildLedger(
        memberIds: const [you, aarav],
        expenses: const [],
        shares: const [],
        settlements: [
          Settlement(
            id: 's1',
            groupId: 'g1',
            fromMemberId: you,
            toMemberId: aarav,
            amountMinor: 50000,
            recordedAt: testNow,
            createdAt: testNow,
          ),
        ],
      );

      expect(ledger.balanceFor(you)!.netMinor, 50000);
      expect(
        ledger.transfers,
        [
          const Transfer(
            fromMemberId: aarav,
            toMemberId: you,
            amountMinor: 50000,
          ),
        ],
        reason: 'paying somebody who owed nothing means they now owe you',
      );
    });
  });

  group('edge cases', () {
    test('a group with nothing spent is square', () {
      final ledger = buildLedger(
        memberIds: everyone,
        expenses: const [],
        shares: const [],
        settlements: const [],
      );

      expect(ledger.isSquare, isTrue);
      expect(ledger.totalMinor, 0);
      expect(ledger.balances, hasLength(4));
    });

    test('one person paying for only themselves owes nobody', () {
      final (solo, soloShares) = expense(
        label: 'Coffee',
        rupees: 200,
        paidBy: you,
        people: const [you],
      );

      final ledger = buildLedger(
        memberIds: everyone,
        expenses: [solo],
        shares: soloShares,
        settlements: const [],
      );

      expect(ledger.isSquare, isTrue);
      expect(ledger.balanceFor(you)!.netMinor, 0);
    });

    test("a deleted expense leaves no trace in anybody's balance", () {
      nextId = 200;
      final (live, liveShares) = expense(
        label: 'Dinner',
        rupees: 2400,
        paidBy: you,
      );
      final (gone, goneShares) = expense(
        label: 'Cancelled hotel',
        rupees: 6000,
        paidBy: aarav,
      );

      final ledger = buildLedger(
        memberIds: everyone,
        expenses: [live, gone.copyWith(deletedAt: testNow)],
        shares: [...liveShares, ...goneShares],
        settlements: const [],
      );

      expect(ledger.totalMinor, 2400 * 100);
      expect(ledger.balanceFor(aarav)!.paidMinor, 0);
      expect(ledger.balanceFor(aarav)!.shareMinor, 600 * 100);
    });

    test('a share belonging to nobody in the group is ignored', () {
      nextId = 300;
      final (live, liveShares) = expense(
        label: 'Dinner',
        rupees: 2400,
        paidBy: you,
      );

      final ledger = buildLedger(
        memberIds: const [you, aarav],
        expenses: [live],
        shares: liveShares,
        settlements: const [],
      );

      expect(
        ledger.balances.map((b) => b.memberId),
        [you, aarav],
        reason: 'Meera and Rohan left the group; their shares do not haunt it',
      );
    });
  });

  group('splitEqually', () {
    test('divides evenly when it can', () {
      expect(
        splitEqually(180000, const [you, meera, rohan]),
        {you: 60000, meera: 60000, rohan: 60000},
      );
    });

    test('hands the remainder to the first members, one unit each', () {
      final shares = splitEqually(100000, const [you, aarav, meera]);

      expect(shares, {you: 33334, aarav: 33333, meera: 33333});
      expect(shares.values.fold<int>(0, (a, b) => a + b), 100000);
    });

    test('always sums to exactly the amount', () {
      for (var amount = 1; amount <= 40; amount++) {
        for (var people = 1; people <= 7; people++) {
          final ids = [for (var i = 0; i < people; i++) 'm$i'];
          final shares = splitEqually(amount, ids);
          expect(
            shares.values.fold<int>(0, (a, b) => a + b),
            amount,
            reason: '$amount across $people people',
          );
        }
      }
    });

    test('a refund takes the remainder rather than giving it', () {
      final shares = splitEqually(-100000, const [you, aarav, meera]);

      expect(shares, {you: -33334, aarav: -33333, meera: -33333});
      expect(shares.values.fold<int>(0, (a, b) => a + b), -100000);
    });

    test('nobody to split between is no shares, not a crash', () {
      expect(splitEqually(100000, const []), isEmpty);
    });
  });
}
