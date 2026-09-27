import 'entities/group.dart';
import 'entities/group_member.dart';
import 'entities/settlement.dart';
import 'entities/shared_expense.dart';
import 'ledger.dart';

/// Reads and writes shared-expense groups (section 6.14).
///
/// Everything here is local. Phase 5 adds invites, member sync and shared
/// writes; nothing in this interface assumes they are missing, so that work
/// should be an implementation change rather than a new shape.
abstract interface class GroupRepository {
  Stream<List<Group>> watchGroups();

  /// The groups filed under one space — what the Travel space detail's trip
  /// card reads.
  Stream<List<Group>> watchGroupsInSpace(String spaceId);

  Stream<Group?> watchGroupById(String id);

  Future<Group?> findGroupById(String id);

  /// Creates a group and puts the user in it as the organiser, because a
  /// group the user is not part of has no "your share" to show and no way to
  /// add themselves afterwards.
  Future<Group> createGroup(NewGroup draft);

  Future<Group> editGroup(
    String id, {
    String? name,
    GroupKind? kind,
    DateTime? startsOn,
    bool clearStartsOn = false,
    DateTime? endsOn,
    bool clearEndsOn = false,
  });

  Future<void> deleteGroup(String id);

  Future<void> restoreGroup(String id);

  /// Members in their stored order — the order the ledger walks.
  Stream<List<GroupMember>> watchMembers(String groupId);

  Future<List<GroupMember>> listMembers(String groupId);

  Future<GroupMember> addMember(String groupId, NewGroupMember draft);

  Future<GroupMember> renameMember(String memberId, String displayName);

  /// Whether a member can leave without leaving money behind.
  ///
  /// False once they have paid for something, owe a share of something, or
  /// are on either side of a settlement. Removing them then would silently
  /// unbalance the ledger — [buildLedger] skips shares belonging to nobody,
  /// so the group's own money would stop adding up.
  Future<bool> canRemoveMember(String memberId);

  /// Removes a member. Throws a [StateError] when [canRemoveMember] is false,
  /// rather than quietly leaving the group's books short.
  Future<void> removeMember(String memberId);

  /// Live expenses, newest first.
  Stream<List<SharedExpense>> watchExpenses(String groupId);

  Stream<SharedExpense?> watchExpenseById(String id);

  Future<SharedExpense?> findExpenseById(String id);

  Future<List<ExpenseShare>> listShares(String expenseId);

  /// Records an expense and its share rows together.
  ///
  /// Throws a [StateError] when [NewSharedExpense.customShares] does not sum
  /// to the amount: a split that does not add up is money appearing from
  /// nowhere, and the one place to catch it is before it is stored.
  Future<SharedExpense> addExpense(String groupId, NewSharedExpense draft);

  Future<void> deleteExpense(String id);

  Future<void> restoreExpense(String id);

  Stream<List<Settlement>> watchSettlements(String groupId);

  Future<Settlement> settle(String groupId, NewSettlement draft);

  Future<void> deleteSettlement(String id);

  Future<void> restoreSettlement(String id);

  /// Where everyone stands and how to square it, recomputed whenever any of
  /// the four things it depends on changes.
  Stream<Ledger> watchLedger(String groupId);

  Future<Ledger> loadLedger(String groupId);
}
