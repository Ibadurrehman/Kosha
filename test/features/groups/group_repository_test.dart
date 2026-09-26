import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/theme/kosha_colors.dart';
import 'package:kosha/features/groups/data/group_repository_impl.dart';
import 'package:kosha/features/groups/domain/entities/group.dart';
import 'package:kosha/features/groups/domain/entities/group_member.dart';
import 'package:kosha/features/groups/domain/entities/settlement.dart';
import 'package:kosha/features/groups/domain/entities/shared_expense.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DriftGroupRepository repository;

  setUp(() {
    db = testDatabase();
    repository = testGroupRepository(db);
  });

  tearDown(() => db.close());

  Future<Group> goa() => repository.createGroup(
        NewGroup(
          name: 'Goa',
          startsOn: DateTime(2026, 10, 12),
          endsOn: DateTime(2026, 10, 16),
        ),
      );

  /// The seed trip's other three members, in Appendix B's order.
  Future<List<GroupMember>> addFriends(String groupId) async => [
        await repository.addMember(
          groupId,
          const NewGroupMember(displayName: 'Aarav Sharma'),
        ),
        await repository.addMember(
          groupId,
          const NewGroupMember(displayName: 'Meera Joshi'),
        ),
        await repository.addMember(
          groupId,
          const NewGroupMember(displayName: 'Rohan Desai'),
        ),
      ];

  group('groups', () {
    test('creating one puts the user in it as the organiser', () async {
      final group = await goa();

      final members = await repository.listMembers(group.id);
      expect(members, hasLength(1));
      expect(members.single.role, MemberRole.organiser);
      expect(
        members.single.profileId,
        isNotNull,
        reason: 'the organiser is the local profile, which is how "your '
            'share" finds itself',
      );
      expect(members.single.isSelf, isTrue);
    });

    test('watchGroupsInSpace only returns that space', () async {
      await repository.createGroup(
        const NewGroup(name: 'Goa', spaceId: 'travel'),
      );
      await repository.createGroup(const NewGroup(name: 'Flat', spaceId: 'home'));

      final travel = await repository.watchGroupsInSpace('travel').first;
      expect(travel.map((g) => g.name), ['Goa']);
    });

    test('deleting is soft and undoes', () async {
      final group = await goa();

      await repository.deleteGroup(group.id);
      expect(await repository.watchGroups().first, isEmpty);
      expect(await repository.watchGroupById(group.id).first, isNull);

      await repository.restoreGroup(group.id);
      expect(await repository.watchGroups().first, hasLength(1));
    });

    test('dates clear through their own sentinel', () async {
      final group = await goa();

      final unchanged = await repository.editGroup(group.id, name: 'Goa trip');
      expect(unchanged.startsOn, DateTime(2026, 10, 12));

      final cleared = await repository.editGroup(
        group.id,
        clearStartsOn: true,
        clearEndsOn: true,
      );
      expect(cleared.startsOn, isNull);
      expect(cleared.endsOn, isNull);
      expect(cleared.name, 'Goa trip');
    });
  });

  group('members', () {
    test('keep the order they were added in', () async {
      final group = await goa();
      await addFriends(group.id);

      final members = await repository.listMembers(group.id);
      expect(
        members.map((m) => m.displayName),
        ['You', 'Aarav Sharma', 'Meera Joshi', 'Rohan Desai'],
      );
    });

    test('get initials and a colour without being told', () async {
      final group = await goa();
      final friends = await addFriends(group.id);

      expect(friends.map((m) => m.initials), ['AS', 'MJ', 'RD']);
      expect(
        friends.map((m) => m.colourIndex),
        [1, 2, 3],
        reason: 'round-robin, so the first four never share a fill',
      );
    });

    test('a fifth member wraps back to the first colour', () async {
      final group = await goa();
      await addFriends(group.id);

      final fifth = await repository.addMember(
        group.id,
        const NewGroupMember(displayName: 'Priya Nair'),
      );

      expect(fifth.colourIndex, 4 % KoshaColors.avatarTones.length);
    });

    test('renaming updates the initials too', () async {
      final group = await goa();
      final aarav = (await addFriends(group.id)).first;

      final renamed = await repository.renameMember(aarav.id, 'Aarav Mehta');
      expect(renamed.displayName, 'Aarav Mehta');
      expect(renamed.initials, 'AM');
    });

    test('one who has touched no money can be removed', () async {
      final group = await goa();
      final aarav = (await addFriends(group.id)).first;

      expect(await repository.canRemoveMember(aarav.id), isTrue);
      await repository.removeMember(aarav.id);

      expect(
        (await repository.listMembers(group.id)).map((m) => m.displayName),
        ['You', 'Meera Joshi', 'Rohan Desai'],
      );
    });

    test('one who owes a share cannot be removed', () async {
      final group = await goa();
      final members = await repository.listMembers(group.id);
      final friends = await addFriends(group.id);
      await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Dinner',
          amountMinor: 240000,
          paidByMemberId: members.first.id,
          memberIds: [members.first.id, friends.first.id],
        ),
      );

      expect(await repository.canRemoveMember(friends.first.id), isFalse);
      expect(
        () => repository.removeMember(friends.first.id),
        throwsStateError,
      );
    });

    test('one who paid for something cannot be removed', () async {
      final group = await goa();
      final members = await repository.listMembers(group.id);
      final aarav = (await addFriends(group.id)).first;
      await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Hotel',
          amountMinor: 600000,
          paidByMemberId: aarav.id,
          memberIds: [members.first.id],
        ),
      );

      expect(await repository.canRemoveMember(aarav.id), isFalse);
    });

    test('one on either side of a settlement cannot be removed', () async {
      final group = await goa();
      final members = await repository.listMembers(group.id);
      final aarav = (await addFriends(group.id)).first;
      await repository.settle(
        group.id,
        NewSettlement(
          fromMemberId: aarav.id,
          toMemberId: members.first.id,
          amountMinor: 100000,
        ),
      );

      expect(await repository.canRemoveMember(aarav.id), isFalse);
      expect(await repository.canRemoveMember(members.first.id), isFalse);
    });

    test('a deleted expense frees its members again', () async {
      final group = await goa();
      final members = await repository.listMembers(group.id);
      final aarav = (await addFriends(group.id)).first;
      final expense = await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Dinner',
          amountMinor: 240000,
          paidByMemberId: members.first.id,
          memberIds: [members.first.id, aarav.id],
        ),
      );

      expect(await repository.canRemoveMember(aarav.id), isFalse);
      await repository.deleteExpense(expense.id);
      expect(await repository.canRemoveMember(aarav.id), isTrue);
    });
  });

  group('expenses', () {
    test('an equal split writes a share row per member', () async {
      final group = await goa();
      final members = await repository.listMembers(group.id);
      final friends = await addFriends(group.id);
      final everyone = [members.first.id, ...friends.map((m) => m.id)];

      final expense = await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Flights',
          amountMinor: 1160000,
          paidByMemberId: members.first.id,
          memberIds: everyone,
        ),
      );

      final shares = await repository.listShares(expense.id);
      expect(shares, hasLength(4));
      expect(shares.map((s) => s.amountMinor).toSet(), {290000});
    });

    test('a split that cannot divide evenly still totals the amount', () async {
      final group = await goa();
      final members = await repository.listMembers(group.id);
      final friends = await addFriends(group.id);

      final expense = await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Chai',
          amountMinor: 1000,
          paidByMemberId: members.first.id,
          memberIds: [members.first.id, friends[0].id, friends[1].id],
        ),
      );

      final shares = await repository.listShares(expense.id);
      expect(
        shares.fold<int>(0, (sum, s) => sum + s.amountMinor),
        1000,
      );
      expect(shares.map((s) => s.amountMinor).toList()..sort(), [333, 333, 334]);
    });

    test('a custom split that does not add up is refused', () async {
      final group = await goa();
      final members = await repository.listMembers(group.id);
      final aarav = (await addFriends(group.id)).first;

      expect(
        () => repository.addExpense(
          group.id,
          NewSharedExpense(
            label: 'Dinner',
            amountMinor: 240000,
            paidByMemberId: members.first.id,
            memberIds: [members.first.id, aarav.id],
            splitMode: SplitMode.custom,
            customShares: {members.first.id: 100000, aarav.id: 100000},
          ),
        ),
        throwsStateError,
      );

      expect(
        await repository.watchExpenses(group.id).first,
        isEmpty,
        reason: 'nothing is stored when the split does not balance',
      );
    });

    test('a custom split that adds up is stored as given', () async {
      final group = await goa();
      final members = await repository.listMembers(group.id);
      final aarav = (await addFriends(group.id)).first;

      final expense = await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Dinner',
          amountMinor: 240000,
          paidByMemberId: members.first.id,
          memberIds: [members.first.id, aarav.id],
          splitMode: SplitMode.custom,
          customShares: {members.first.id: 200000, aarav.id: 40000},
        ),
      );

      final shares = await repository.listShares(expense.id);
      expect(
        {for (final s in shares) s.memberId: s.amountMinor},
        {members.first.id: 200000, aarav.id: 40000},
      );
      expect(expense.splitMode, SplitMode.custom);
    });

    test('splitting between nobody is refused', () async {
      final group = await goa();
      final members = await repository.listMembers(group.id);

      expect(
        () => repository.addExpense(
          group.id,
          NewSharedExpense(
            label: 'Nothing',
            amountMinor: 1000,
            paidByMemberId: members.first.id,
            memberIds: const [],
          ),
        ),
        throwsStateError,
      );
    });

    test('deleting is soft, and the shares wait for the undo', () async {
      final group = await goa();
      final members = await repository.listMembers(group.id);
      final aarav = (await addFriends(group.id)).first;
      final expense = await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Dinner',
          amountMinor: 240000,
          paidByMemberId: members.first.id,
          memberIds: [members.first.id, aarav.id],
        ),
      );

      await repository.deleteExpense(expense.id);
      expect(await repository.watchExpenses(group.id).first, isEmpty);
      expect(
        await repository.listShares(expense.id),
        hasLength(2),
        reason: 'the split is untouched, so undo is one row write',
      );

      await repository.restoreExpense(expense.id);
      expect(await repository.watchExpenses(group.id).first, hasLength(1));
    });
  });

  group('the ledger over real rows', () {
    test('reproduces Appendix B end to end', () async {
      final group = await goa();
      final you = (await repository.listMembers(group.id)).single;
      final friends = await addFriends(group.id);
      final aarav = friends[0];
      final meera = friends[1];
      final rohan = friends[2];
      final everyone = [you.id, aarav.id, meera.id, rohan.id];

      await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Flights — IndiGo 6E-573',
          amountMinor: 1160000,
          paidByMemberId: you.id,
          memberIds: everyone,
        ),
      );
      await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Hotel deposit',
          amountMinor: 600000,
          paidByMemberId: aarav.id,
          memberIds: everyone,
        ),
      );
      await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Scooter rental',
          amountMinor: 180000,
          paidByMemberId: meera.id,
          memberIds: [you.id, meera.id, rohan.id],
          splitMode: SplitMode.custom,
        ),
      );
      await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Dinner at Gunpowder',
          amountMinor: 240000,
          paidByMemberId: you.id,
          memberIds: everyone,
        ),
      );

      final ledger = await repository.loadLedger(group.id);

      expect(ledger.balanceFor(you.id)!.netMinor, 840000);
      expect(ledger.balanceFor(aarav.id)!.netMinor, 100000);
      expect(ledger.balanceFor(meera.id)!.netMinor, -380000);
      expect(ledger.balanceFor(rohan.id)!.netMinor, -560000);
      expect(ledger.transfers, hasLength(3));
      expect(ledger.totalMinor, 2180000);

      final first = ledger.transfers.first;
      expect(first.fromMemberId, meera.id);
      expect(first.toMemberId, you.id);
      expect(first.amountMinor, 380000);
    });

    test('settling a suggested transfer squares that member', () async {
      final group = await goa();
      final you = (await repository.listMembers(group.id)).single;
      final aarav = (await addFriends(group.id)).first;
      await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Dinner',
          amountMinor: 240000,
          paidByMemberId: you.id,
          memberIds: [you.id, aarav.id],
        ),
      );

      final before = await repository.loadLedger(group.id);
      expect(before.transfers, hasLength(1));

      await repository.settle(
        group.id,
        NewSettlement(
          fromMemberId: aarav.id,
          toMemberId: you.id,
          amountMinor: before.transfers.single.amountMinor,
        ),
      );

      final after = await repository.loadLedger(group.id);
      expect(after.isSquare, isTrue);
    });

    test('a deleted settlement puts the debt back', () async {
      final group = await goa();
      final you = (await repository.listMembers(group.id)).single;
      final aarav = (await addFriends(group.id)).first;
      await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Dinner',
          amountMinor: 240000,
          paidByMemberId: you.id,
          memberIds: [you.id, aarav.id],
        ),
      );
      final settlement = await repository.settle(
        group.id,
        NewSettlement(
          fromMemberId: aarav.id,
          toMemberId: you.id,
          amountMinor: 120000,
        ),
      );
      expect((await repository.loadLedger(group.id)).isSquare, isTrue);

      await repository.deleteSettlement(settlement.id);
      expect((await repository.loadLedger(group.id)).transfers, hasLength(1));
    });

    test('one group never sees another group money', () async {
      final goaTrip = await goa();
      final flat = await repository.createGroup(const NewGroup(name: 'Flat'));
      final goaYou = (await repository.listMembers(goaTrip.id)).single;
      final flatYou = (await repository.listMembers(flat.id)).single;
      final aarav = (await addFriends(goaTrip.id)).first;

      await repository.addExpense(
        goaTrip.id,
        NewSharedExpense(
          label: 'Dinner',
          amountMinor: 240000,
          paidByMemberId: goaYou.id,
          memberIds: [goaYou.id, aarav.id],
        ),
      );

      final flatLedger = await repository.loadLedger(flat.id);
      expect(flatLedger.totalMinor, 0);
      expect(flatLedger.isSquare, isTrue);
      expect(flatLedger.balances.map((b) => b.memberId), [flatYou.id]);
    });

    test('watchLedger re-emits when an expense lands', () async {
      final group = await goa();
      final you = (await repository.listMembers(group.id)).single;
      final aarav = (await addFriends(group.id)).first;

      final seen = <int>[];
      final subscription = repository
          .watchLedger(group.id)
          .listen((ledger) => seen.add(ledger.totalMinor));
      await pumpEventQueue();

      await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Dinner',
          amountMinor: 240000,
          paidByMemberId: you.id,
          memberIds: [you.id, aarav.id],
        ),
      );
      await pumpEventQueue();
      await subscription.cancel();

      expect(seen.first, 0);
      expect(seen.last, 240000);
    });
  });
}
