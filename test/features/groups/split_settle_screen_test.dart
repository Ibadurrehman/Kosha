import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/groups/data/group_repository_impl.dart';
import 'package:kosha/features/groups/domain/entities/group.dart';
import 'package:kosha/features/groups/domain/entities/group_member.dart';
import 'package:kosha/features/groups/domain/entities/settlement.dart';
import 'package:kosha/features/groups/domain/entities/shared_expense.dart';
import 'package:kosha/features/groups/presentation/split_settle_screen.dart';
import 'package:kosha/features/groups/presentation/widgets/shared_expense_sheet.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DriftGroupRepository repository;

  setUp(() {
    db = testDatabase();
    repository = testGroupRepository(db);
  });

  tearDown(() => db.close());

  /// The Goa trip with all four of Appendix B's members.
  Future<(Group, List<GroupMember>)> goaWithFriends() async {
    final group = await repository.createGroup(
      NewGroup(
        name: 'Goa',
        startsOn: DateTime(2026, 10, 12),
        endsOn: DateTime(2026, 10, 16),
      ),
    );
    for (final name in ['Aarav Sharma', 'Meera Joshi', 'Rohan Desai']) {
      await repository.addMember(group.id, NewGroupMember(displayName: name));
    }
    return (group, await repository.listMembers(group.id));
  }

  Future<void> pumpSettle(WidgetTester tester, String groupId) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      wrapPushedScreen(SplitSettleScreen(groupId: groupId), db: db),
    );
    await tester.pumpAndSettle();
  }

  group('split & settle up', () {
    testWidgets('a group with nothing spent says everyone is square',
        (tester) async {
      final (group, _) = await goaWithFriends();
      await pumpSettle(tester, group.id);

      expect(find.text("Everyone's square"), findsOneWidget);
      expect(find.text('You are square'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('shows the trip, its dates and the group total',
        (tester) async {
      final (group, members) = await goaWithFriends();
      await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Dinner',
          amountMinor: 240000,
          paidByMemberId: members.first.id,
          memberIds: [for (final m in members) m.id],
        ),
      );
      await pumpSettle(tester, group.id);

      expect(find.text('Goa'), findsWidgets);
      expect(find.textContaining('12 Oct'), findsOneWidget);
      expect(find.text('₹2,400 in total'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('lists the suggested transfers Appendix B expects',
        (tester) async {
      final (group, members) = await goaWithFriends();
      final you = members[0];
      final aarav = members[1];
      final meera = members[2];
      final rohan = members[3];
      final everyone = [for (final m in members) m.id];

      await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Flights',
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
        ),
      );
      await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Dinner',
          amountMinor: 240000,
          paidByMemberId: you.id,
          memberIds: everyone,
        ),
      );

      await pumpSettle(tester, group.id);

      expect(find.text("Everyone's square"), findsNothing);
      expect(find.text('Meera Joshi pays You'), findsOneWidget);
      expect(find.text('₹3,800'), findsOneWidget);
      expect(find.text('Rohan Desai pays You'), findsOneWidget);
      expect(find.text('₹4,600'), findsOneWidget);
      expect(find.text('Rohan Desai pays Aarav Sharma'), findsOneWidget);
      expect(find.text('You are owed ₹8,400'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('Pay records a settlement and the row goes', (tester) async {
      final (group, members) = await goaWithFriends();
      await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Dinner',
          amountMinor: 240000,
          paidByMemberId: members.first.id,
          memberIds: [members.first.id, members[1].id],
        ),
      );
      await pumpSettle(tester, group.id);

      expect(find.text('Aarav Sharma pays You'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Pay'));
      await tester.pumpAndSettle();

      expect(find.text("Everyone's square"), findsOneWidget);

      late List<Settlement> settlements;
      await tester.runAsync(() async {
        settlements = await repository.watchSettlements(group.id).first;
      });
      expect(settlements, hasLength(1));
      expect(settlements.single.amountMinor, 120000);
      await settleAndDispose(tester);
    });

    testWidgets('Remind says what it will do rather than pretending',
        (tester) async {
      final (group, members) = await goaWithFriends();
      await repository.addExpense(
        group.id,
        NewSharedExpense(
          label: 'Dinner',
          amountMinor: 240000,
          paidByMemberId: members.first.id,
          memberIds: [members.first.id, members[1].id],
        ),
      );
      await pumpSettle(tester, group.id);

      await tester.tap(find.widgetWithText(TextButton, 'Remind'));
      await tester.pump();

      expect(
        find.textContaining('arrive with shared groups'),
        findsOneWidget,
      );
      await settleAndDispose(tester);
    });

    testWidgets('a deleted group says so rather than throwing', (tester) async {
      final (group, _) = await goaWithFriends();
      await repository.deleteGroup(group.id);
      await pumpSettle(tester, group.id);

      expect(find.text('This group is gone'), findsOneWidget);
      await settleAndDispose(tester);
    });
  });

  group('the shared expense sheet', () {
    Future<void> openSheet(WidgetTester tester, String groupId) async {
      await pumpSettle(tester, groupId);
      await tester.scrollUntilVisible(
        find.text('Add a shared expense'),
        300,
      );
      await tester.tap(find.text('Add a shared expense'));
      await tester.pumpAndSettle();
    }

    testWidgets('starts split between everybody, equally', (tester) async {
      final (group, _) = await goaWithFriends();
      await openSheet(tester, group.id);

      expect(find.text('Equally'), findsOneWidget);
      for (final name in ['Aarav Sharma', 'Meera Joshi', 'Rohan Desai']) {
        expect(find.text(name), findsWidgets);
      }
      final checkboxes = tester
          .widgetList<Checkbox>(find.byType(Checkbox))
          .map((box) => box.value);
      expect(checkboxes, everyElement(isTrue));
      await settleAndDispose(tester);
    });

    testWidgets('Save waits for an amount', (tester) async {
      final (group, _) = await goaWithFriends();
      await openSheet(tester, group.id);

      FilledButton save() => tester.widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Add expense'),
          );
      expect(save().onPressed, isNull);

      await tester.tap(find.text('5'));
      await tester.pump();
      expect(save().onPressed, isNotNull);
      await settleAndDispose(tester);
    });

    testWidgets('unticking somebody switches the split to Custom',
        (tester) async {
      final (group, _) = await goaWithFriends();
      await openSheet(tester, group.id);

      await tester.tap(
        find.bySemanticsLabel('Split with Rohan Desai'),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining('split 3 ways'),
        findsOneWidget,
        reason: 'the preview follows the ticks, not the chip',
      );
      await settleAndDispose(tester);
    });

    testWidgets('"Only me" leaves just the user ticked', (tester) async {
      final (group, _) = await goaWithFriends();
      await openSheet(tester, group.id);

      await tester.tap(find.text('Only me'));
      await tester.pumpAndSettle();

      final ticked = tester
          .widgetList<Checkbox>(find.byType(Checkbox))
          .where((box) => box.value ?? false);
      expect(ticked, hasLength(1));
      await settleAndDispose(tester);
    });

    testWidgets('saving writes the expense and its shares', (tester) async {
      final (group, _) = await goaWithFriends();
      await openSheet(tester, group.id);

      // ₹400 across four people.
      for (final key in ['4', '0', '0']) {
        await tester.tap(find.text(key));
        await tester.pump();
      }
      expect(find.text('₹400.00'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextField, 'Dinner at Gunpowder'),
        'Dinner',
      );
      await tester.pump();

      // The sheet is taller than the viewport, so Save has to be scrolled to
      // before it can be tapped -- the same thing a user does on a phone.
      final save = find.descendant(
        of: find.byType(SharedExpenseSheet),
        matching: find.widgetWithText(FilledButton, 'Add expense'),
      );
      await tester.ensureVisible(save);
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(save).onPressed, isNotNull);
      await tester.tap(save);
      await tester.pumpAndSettle();

      late List<SharedExpense> expenses;
      late List<ExpenseShare> shares;
      await tester.runAsync(() async {
        expenses = await repository.watchExpenses(group.id).first;
        shares = await repository.listShares(expenses.single.id);
      });

      expect(expenses.single.label, 'Dinner');
      expect(expenses.single.amountMinor, 40000);
      expect(shares, hasLength(4));
      expect(shares.map((s) => s.amountMinor).toSet(), {10000});
      await settleAndDispose(tester);
    });
  });
}
