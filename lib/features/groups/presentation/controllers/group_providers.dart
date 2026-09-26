import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/group_repository_impl.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/group_member.dart';
import '../../domain/entities/settlement.dart';
import '../../domain/entities/shared_expense.dart';
import '../../domain/ledger.dart';

part 'group_providers.g.dart';

/// The groups filed under one space — what the space detail's trip card reads.
/// A space with none shows the card's "start one" state instead.
@riverpod
Stream<List<Group>> groupsInSpace(Ref ref, String spaceId) =>
    ref.watch(groupRepositoryProvider).watchGroupsInSpace(spaceId);

@riverpod
Stream<Group?> groupById(Ref ref, String groupId) =>
    ref.watch(groupRepositoryProvider).watchGroupById(groupId);

/// Members in their stored order, which is the order the ledger walks.
@riverpod
Stream<List<GroupMember>> groupMembers(Ref ref, String groupId) =>
    ref.watch(groupRepositoryProvider).watchMembers(groupId);

@riverpod
Stream<List<SharedExpense>> groupExpenses(Ref ref, String groupId) =>
    ref.watch(groupRepositoryProvider).watchExpenses(groupId);

@riverpod
Stream<List<Settlement>> groupSettlements(Ref ref, String groupId) =>
    ref.watch(groupRepositoryProvider).watchSettlements(groupId);

/// Where everyone stands, recomputed on any write that could move it.
@riverpod
Stream<Ledger> groupLedger(Ref ref, String groupId) =>
    ref.watch(groupRepositoryProvider).watchLedger(groupId);
