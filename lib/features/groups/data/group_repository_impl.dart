import 'dart:async';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/app_database.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/utils/clock.dart';
import '../../onboarding/data/profile_repository_impl.dart';
import '../../onboarding/domain/profile_repository.dart';
import '../domain/entities/group.dart';
import '../domain/entities/group_member.dart';
import '../domain/entities/settlement.dart';
import '../domain/entities/shared_expense.dart';
import '../domain/group_repository.dart';
import '../domain/ledger.dart';

part 'group_repository_impl.g.dart';

/// SQLite-backed shared-expense groups.
///
/// The one rule that shapes this class: money must always add up. Shares are
/// written with their expense in a single transaction, a custom split that
/// does not total the amount is refused rather than stored, and a member who
/// has touched any money cannot be removed. Everything the ledger reads is
/// therefore a set of whole minor units that sums to zero.
class DriftGroupRepository implements GroupRepository {
  DriftGroupRepository(this._db, this._clock, this._profiles);

  static const Uuid _uuid = Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final ProfileRepository _profiles;

  @override
  Stream<List<Group>> watchGroups() {
    final query = _db.select(_db.groups)
      ..where((g) => g.deletedAt.isNull())
      ..orderBy([(g) => OrderingTerm.desc(g.createdAt)]);
    return query.watch().map((rows) => rows.map(_toGroup).toList());
  }

  @override
  Stream<List<Group>> watchGroupsInSpace(String spaceId) {
    final query = _db.select(_db.groups)
      ..where((g) => g.deletedAt.isNull() & g.spaceId.equals(spaceId))
      ..orderBy([(g) => OrderingTerm.desc(g.createdAt)]);
    return query.watch().map((rows) => rows.map(_toGroup).toList());
  }

  @override
  Stream<Group?> watchGroupById(String id) {
    final query = _db.select(_db.groups)
      ..where((g) => g.id.equals(id) & g.deletedAt.isNull());
    return query
        .watchSingleOrNull()
        .map((row) => row == null ? null : _toGroup(row));
  }

  @override
  Future<Group?> findGroupById(String id) async {
    final row = await (_db.select(_db.groups)..where((g) => g.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toGroup(row);
  }

  @override
  Future<Group> createGroup(NewGroup draft) async {
    final now = _clock.now();
    final group = Group(
      id: _uuid.v4(),
      name: draft.name,
      kind: draft.kind,
      spaceId: draft.spaceId,
      currency: draft.currency,
      startsOn: draft.startsOn,
      endsOn: draft.endsOn,
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.groups).insert(_toGroupRow(group));

    // The user joins their own group first, as the organiser. A group they
    // were not in would show no "your share" line and offer no way to add
    // themselves — §6.14's whole screen is written from their side.
    final profile = await _profiles.current();
    await addMember(
      group.id,
      NewGroupMember(
        displayName: profile.name.trim().isEmpty ? 'You' : profile.name,
        initials: profile.avatarInitials,
        role: MemberRole.organiser,
        profileId: profile.id,
      ),
    );
    return group;
  }

  @override
  Future<Group> editGroup(
    String id, {
    String? name,
    GroupKind? kind,
    DateTime? startsOn,
    bool clearStartsOn = false,
    DateTime? endsOn,
    bool clearEndsOn = false,
  }) async {
    await (_db.update(_db.groups)..where((g) => g.id.equals(id))).write(
      GroupsCompanion(
        name: name == null ? const Value.absent() : Value(name),
        kind: kind == null ? const Value.absent() : Value(kind),
        startsOn: clearStartsOn
            ? const Value(null)
            : (startsOn == null ? const Value.absent() : Value(startsOn)),
        endsOn: clearEndsOn
            ? const Value(null)
            : (endsOn == null ? const Value.absent() : Value(endsOn)),
        updatedAt: Value(_clock.now()),
      ),
    );
    return _requireGroup(id);
  }

  @override
  Future<void> deleteGroup(String id) async {
    final now = _clock.now();
    await (_db.update(_db.groups)..where((g) => g.id.equals(id))).write(
      GroupsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  @override
  Future<void> restoreGroup(String id) async {
    await (_db.update(_db.groups)..where((g) => g.id.equals(id))).write(
      GroupsCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_clock.now()),
      ),
    );
  }

  @override
  Stream<List<GroupMember>> watchMembers(String groupId) =>
      _memberQuery(groupId).watch().map((rows) => rows.map(_toMember).toList());

  @override
  Future<List<GroupMember>> listMembers(String groupId) async {
    final rows = await _memberQuery(groupId).get();
    return rows.map(_toMember).toList();
  }

  @override
  Future<GroupMember> addMember(String groupId, NewGroupMember draft) async {
    final now = _clock.now();
    final existing = await listMembers(groupId);
    final member = GroupMember(
      id: _uuid.v4(),
      groupId: groupId,
      displayName: draft.displayName,
      initials: draft.initials?.trim().isNotEmpty ?? false
          ? draft.initials!.trim()
          : initialsFor(draft.displayName),
      // Round-robin, so the first four members of a trip never share a fill.
      colourIndex:
          draft.colourIndex ?? existing.length % KoshaColors.avatarTones.length,
      role: draft.role,
      profileId: draft.profileId,
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.groupMembers).insert(
          _toMemberRow(member, sortOrder: existing.length),
        );
    return member;
  }

  @override
  Future<GroupMember> renameMember(String memberId, String displayName) async {
    await (_db.update(_db.groupMembers)..where((m) => m.id.equals(memberId)))
        .write(
      GroupMembersCompanion(
        displayName: Value(displayName),
        initials: Value(initialsFor(displayName)),
        updatedAt: Value(_clock.now()),
      ),
    );
    return _requireMember(memberId);
  }

  @override
  Future<bool> canRemoveMember(String memberId) async {
    final paid = await (_db.select(_db.sharedExpenses)
          ..where(
            (e) => e.paidByMemberId.equals(memberId) & e.deletedAt.isNull(),
          )
          ..limit(1))
        .getSingleOrNull();
    if (paid != null) return false;

    final share = await (_db.select(_db.expenseShares).join([
      innerJoin(
        _db.sharedExpenses,
        _db.sharedExpenses.id.equalsExp(_db.expenseShares.sharedExpenseId),
      ),
    ])
          ..where(
            _db.expenseShares.memberId.equals(memberId) &
                _db.sharedExpenses.deletedAt.isNull(),
          )
          ..limit(1))
        .getSingleOrNull();
    if (share != null) return false;

    final settlement = await (_db.select(_db.settlements)
          ..where(
            (s) =>
                (s.fromMemberId.equals(memberId) |
                    s.toMemberId.equals(memberId)) &
                s.deletedAt.isNull(),
          )
          ..limit(1))
        .getSingleOrNull();
    return settlement == null;
  }

  @override
  Future<void> removeMember(String memberId) async {
    if (!await canRemoveMember(memberId)) {
      throw StateError(
        'Member $memberId is part of the group\'s money and cannot be removed',
      );
    }
    final now = _clock.now();
    await (_db.update(_db.groupMembers)..where((m) => m.id.equals(memberId)))
        .write(
      GroupMembersCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  @override
  Stream<List<SharedExpense>> watchExpenses(String groupId) {
    final query = _db.select(_db.sharedExpenses)
      ..where((e) => e.groupId.equals(groupId) & e.deletedAt.isNull())
      ..orderBy([
        (e) => OrderingTerm.desc(e.date),
        (e) => OrderingTerm.desc(e.createdAt),
      ]);
    return query.watch().map((rows) => rows.map(_toExpense).toList());
  }

  @override
  Stream<SharedExpense?> watchExpenseById(String id) {
    final query = _db.select(_db.sharedExpenses)
      ..where((e) => e.id.equals(id) & e.deletedAt.isNull());
    return query
        .watchSingleOrNull()
        .map((row) => row == null ? null : _toExpense(row));
  }

  @override
  Future<SharedExpense?> findExpenseById(String id) async {
    final row = await (_db.select(_db.sharedExpenses)
          ..where((e) => e.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toExpense(row);
  }

  @override
  Future<List<ExpenseShare>> listShares(String expenseId) async {
    final rows = await (_db.select(_db.expenseShares)
          ..where((s) => s.sharedExpenseId.equals(expenseId)))
        .get();
    return rows.map(_toShare).toList();
  }

  @override
  Future<SharedExpense> addExpense(
    String groupId,
    NewSharedExpense draft,
  ) async {
    if (draft.memberIds.isEmpty) {
      throw StateError('An expense has to be split between somebody');
    }

    final shares = draft.customShares ??
        splitEqually(draft.amountMinor, draft.memberIds);
    final total = shares.values.fold<int>(0, (sum, value) => sum + value);
    if (total != draft.amountMinor) {
      throw StateError(
        'Shares total $total, which is not the expense amount '
        '${draft.amountMinor}',
      );
    }

    final now = _clock.now();
    final expense = SharedExpense(
      id: _uuid.v4(),
      groupId: groupId,
      label: draft.label,
      amountMinor: draft.amountMinor,
      paidByMemberId: draft.paidByMemberId,
      splitMode: draft.splitMode,
      iconKey: draft.iconKey,
      date: draft.date ?? now,
      createdAt: now,
      updatedAt: now,
    );

    // One transaction: an expense whose shares failed to write would be money
    // owed by nobody, and the ledger would stop balancing.
    await _db.transaction(() async {
      await _db.into(_db.sharedExpenses).insert(_toExpenseRow(expense));
      for (final entry in shares.entries) {
        await _db.into(_db.expenseShares).insert(
              ExpenseSharesCompanion.insert(
                id: _uuid.v4(),
                sharedExpenseId: expense.id,
                memberId: entry.key,
                amountMinor: entry.value,
              ),
            );
      }
    });
    return expense;
  }

  @override
  Future<void> deleteExpense(String id) async {
    final now = _clock.now();
    await (_db.update(_db.sharedExpenses)..where((e) => e.id.equals(id))).write(
      SharedExpensesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  @override
  Future<void> restoreExpense(String id) async {
    await (_db.update(_db.sharedExpenses)..where((e) => e.id.equals(id))).write(
      SharedExpensesCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_clock.now()),
      ),
    );
  }

  @override
  Stream<List<Settlement>> watchSettlements(String groupId) {
    final query = _db.select(_db.settlements)
      ..where((s) => s.groupId.equals(groupId) & s.deletedAt.isNull())
      ..orderBy([(s) => OrderingTerm.desc(s.recordedAt)]);
    return query.watch().map((rows) => rows.map(_toSettlement).toList());
  }

  @override
  Future<Settlement> settle(String groupId, NewSettlement draft) async {
    final now = _clock.now();
    final settlement = Settlement(
      id: _uuid.v4(),
      groupId: groupId,
      fromMemberId: draft.fromMemberId,
      toMemberId: draft.toMemberId,
      amountMinor: draft.amountMinor,
      method: draft.method,
      note: draft.note,
      recordedAt: draft.recordedAt ?? now,
      createdAt: now,
    );
    await _db.into(_db.settlements).insert(_toSettlementRow(settlement));
    return settlement;
  }

  @override
  Future<void> deleteSettlement(String id) async {
    await (_db.update(_db.settlements)..where((s) => s.id.equals(id))).write(
      SettlementsCompanion(deletedAt: Value(_clock.now())),
    );
  }

  @override
  Future<void> restoreSettlement(String id) async {
    await (_db.update(_db.settlements)..where((s) => s.id.equals(id))).write(
      const SettlementsCompanion(deletedAt: Value(null)),
    );
  }

  @override
  Future<Ledger> loadLedger(String groupId) async {
    final members = await listMembers(groupId);
    final expenseRows = await (_db.select(_db.sharedExpenses)
          ..where((e) => e.groupId.equals(groupId) & e.deletedAt.isNull()))
        .get();
    final expenses = expenseRows.map(_toExpense).toList();

    final shareRows = await (_db.select(_db.expenseShares).join([
      innerJoin(
        _db.sharedExpenses,
        _db.sharedExpenses.id.equalsExp(_db.expenseShares.sharedExpenseId),
      ),
    ])..where(_db.sharedExpenses.groupId.equals(groupId)))
        .get();
    final shares = [
      for (final row in shareRows) _toShare(row.readTable(_db.expenseShares)),
    ];

    final settlementRows = await (_db.select(_db.settlements)
          ..where((s) => s.groupId.equals(groupId) & s.deletedAt.isNull()))
        .get();

    return buildLedger(
      memberIds: [for (final member in members) member.id],
      expenses: expenses,
      shares: shares,
      settlements: settlementRows.map(_toSettlement).toList(),
    );
  }

  /// Recomputed on any write to the four tables it reads.
  ///
  /// A ledger is a fold over four differently-shaped queries, which is not
  /// what `combineLatestLists` does — that merges lists of one type. Watching
  /// the tables themselves and reloading says the same thing in one line, and
  /// says it about exactly the tables [loadLedger] reads.
  ///
  /// The update subscription is opened *before* the first load, so a write
  /// landing between the two is still seen. The other order would leave the
  /// screen quietly stale until the next unrelated change.
  @override
  Stream<Ledger> watchLedger(String groupId) {
    late final StreamController<Ledger> controller;
    StreamSubscription<void>? updates;
    var loading = false;
    var again = false;

    Future<void> reload() async {
      if (loading) {
        again = true;
        return;
      }
      loading = true;
      try {
        do {
          again = false;
          final ledger = await loadLedger(groupId);
          if (controller.isClosed) return;
          controller.add(ledger);
        } while (again);
      } on Object catch (error, stack) {
        if (!controller.isClosed) controller.addError(error, stack);
      } finally {
        loading = false;
      }
    }

    controller = StreamController<Ledger>(
      onListen: () {
        updates = _db
            .tableUpdates(
              TableUpdateQuery.onAllTables([
                _db.groupMembers,
                _db.sharedExpenses,
                _db.expenseShares,
                _db.settlements,
              ]),
            )
            .listen((_) => unawaited(reload()));
        unawaited(reload());
      },
      onCancel: () {
        // Fired without awaiting, for the reason §12.1.3 records: awaiting a
        // drift subscription's cancel chains its zero-duration close timer
        // into whatever cancels next, which hangs a widget test. An in-flight
        // reload checks `isClosed` before it adds, so closing here cannot
        // land an event on a cancelled listener.
        unawaited(updates?.cancel());
        updates = null;
        unawaited(controller.close());
      },
    );
    return controller.stream;
  }

  SimpleSelectStatement<$GroupMembersTable, GroupMemberRow> _memberQuery(
    String groupId,
  ) =>
      _db.select(_db.groupMembers)
        ..where((m) => m.groupId.equals(groupId) & m.deletedAt.isNull())
        ..orderBy([(m) => OrderingTerm.asc(m.sortOrder)]);

  Future<Group> _requireGroup(String id) async {
    final group = await findGroupById(id);
    if (group == null) throw StateError('No group with id $id');
    return group;
  }

  Future<GroupMember> _requireMember(String id) async {
    final row = await (_db.select(_db.groupMembers)
          ..where((m) => m.id.equals(id)))
        .getSingleOrNull();
    if (row == null) throw StateError('No member with id $id');
    return _toMember(row);
  }

  Group _toGroup(GroupRow row) => Group(
        id: row.id,
        name: row.name,
        kind: row.kind,
        spaceId: row.spaceId,
        currency: row.currency,
        startsOn: row.startsOn,
        endsOn: row.endsOn,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
      );

  GroupsCompanion _toGroupRow(Group group) => GroupsCompanion.insert(
        id: group.id,
        name: group.name,
        kind: group.kind,
        spaceId: Value(group.spaceId),
        currency: Value(group.currency),
        startsOn: Value(group.startsOn),
        endsOn: Value(group.endsOn),
        createdAt: group.createdAt,
        updatedAt: group.updatedAt,
        deletedAt: Value(group.deletedAt),
      );

  GroupMember _toMember(GroupMemberRow row) => GroupMember(
        id: row.id,
        groupId: row.groupId,
        displayName: row.displayName,
        initials: row.initials,
        colourIndex: row.colourIndex,
        role: row.role,
        profileId: row.profileId,
        inviteToken: row.inviteToken,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
      );

  GroupMembersCompanion _toMemberRow(
    GroupMember member, {
    required int sortOrder,
  }) =>
      GroupMembersCompanion.insert(
        id: member.id,
        groupId: member.groupId,
        displayName: member.displayName,
        initials: member.initials,
        colourIndex: Value(member.colourIndex),
        role: member.role,
        sortOrder: sortOrder,
        profileId: Value(member.profileId),
        inviteToken: Value(member.inviteToken),
        createdAt: member.createdAt,
        updatedAt: member.updatedAt,
        deletedAt: Value(member.deletedAt),
      );

  SharedExpense _toExpense(SharedExpenseRow row) => SharedExpense(
        id: row.id,
        groupId: row.groupId,
        label: row.label,
        amountMinor: row.amountMinor,
        paidByMemberId: row.paidByMemberId,
        splitMode: row.splitMode,
        iconKey: row.iconKey,
        date: row.date,
        transactionId: row.transactionId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
      );

  SharedExpensesCompanion _toExpenseRow(SharedExpense expense) =>
      SharedExpensesCompanion.insert(
        id: expense.id,
        groupId: expense.groupId,
        label: expense.label,
        amountMinor: expense.amountMinor,
        paidByMemberId: expense.paidByMemberId,
        splitMode: expense.splitMode,
        iconKey: Value(expense.iconKey),
        date: expense.date,
        transactionId: Value(expense.transactionId),
        createdAt: expense.createdAt,
        updatedAt: expense.updatedAt,
        deletedAt: Value(expense.deletedAt),
      );

  ExpenseShare _toShare(ExpenseShareRow row) => ExpenseShare(
        id: row.id,
        sharedExpenseId: row.sharedExpenseId,
        memberId: row.memberId,
        amountMinor: row.amountMinor,
      );

  Settlement _toSettlement(SettlementRow row) => Settlement(
        id: row.id,
        groupId: row.groupId,
        fromMemberId: row.fromMemberId,
        toMemberId: row.toMemberId,
        amountMinor: row.amountMinor,
        method: row.method,
        note: row.note,
        recordedAt: row.recordedAt,
        createdAt: row.createdAt,
        deletedAt: row.deletedAt,
      );

  SettlementsCompanion _toSettlementRow(Settlement settlement) =>
      SettlementsCompanion.insert(
        id: settlement.id,
        groupId: settlement.groupId,
        fromMemberId: settlement.fromMemberId,
        toMemberId: settlement.toMemberId,
        amountMinor: settlement.amountMinor,
        method: settlement.method,
        note: Value(settlement.note),
        recordedAt: settlement.recordedAt,
        createdAt: settlement.createdAt,
        deletedAt: Value(settlement.deletedAt),
      );
}

@Riverpod(keepAlive: true)
GroupRepository groupRepository(Ref ref) => DriftGroupRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(clockProvider),
      ref.watch(profileRepositoryProvider),
    );
