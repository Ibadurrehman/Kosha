import 'package:drift/drift.dart';

import '../domain/entities/group.dart';
import '../domain/entities/group_member.dart';
import '../domain/entities/settlement.dart';
import '../domain/entities/shared_expense.dart';

/// Shared-expense groups (section 6.14). The row class is `GroupRow` to match
/// the `TaskRow`/`Task` naming split — and because `Group` is also a Flutter
/// class name.
///
/// v1 groups are local. Phase 5 turns them into shared ones, which is why the
/// columns it will need (`currency` here, `profileId`/`inviteToken` on
/// members) are present and unwritten rather than added later to a table that
/// by then holds real trips.
@DataClassName('GroupRow')
@TableIndex(name: 'groups_space', columns: {#spaceId})
class Groups extends Table {
  TextColumn get id => text()();

  TextColumn get name => text().withLength(min: 1, max: 200)();

  IntColumn get kind => intEnum<GroupKind>()();

  TextColumn get spaceId => text().nullable()();

  TextColumn get currency => text().withDefault(const Constant('INR'))();

  DateTimeColumn get startsOn => dateTime().nullable()();

  DateTimeColumn get endsOn => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// The people in a group.
///
/// `sortOrder` is what the ledger walks: the prototype's `ledger()` filters
/// its members in declaration order and never sorts by size of debt, and
/// Appendix B's expected transfers are the ones that order produces. Without
/// a stored order the suggested payments would quietly change whenever two
/// members happened to be created in the same millisecond.
@DataClassName('GroupMemberRow')
@TableIndex(name: 'group_members_group', columns: {#groupId, #sortOrder})
class GroupMembers extends Table {
  TextColumn get id => text()();

  TextColumn get groupId => text()();

  TextColumn get displayName => text().withLength(min: 1, max: 200)();

  TextColumn get initials => text().withLength(min: 1, max: 4)();

  /// An index into `KoshaColors.avatarTones` — see [GroupMember.colourIndex].
  IntColumn get colourIndex => integer().withDefault(const Constant(0))();

  IntColumn get role => intEnum<MemberRole>()();

  IntColumn get sortOrder => integer()();

  /// Null until Phase 5 matches this member to an account — except for the
  /// member who is the user themselves, which is how "your share" is found.
  TextColumn get profileId => text().nullable()();

  TextColumn get inviteToken => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Money somebody laid out for the group.
@DataClassName('SharedExpenseRow')
@TableIndex(name: 'shared_expenses_group', columns: {#groupId, #date})
class SharedExpenses extends Table {
  TextColumn get id => text()();

  TextColumn get groupId => text()();

  TextColumn get label => text().withLength(min: 1, max: 500)();

  IntColumn get amountMinor => integer()();

  TextColumn get paidByMemberId => text()();

  IntColumn get splitMode => intEnum<SplitMode>()();

  TextColumn get iconKey => text().withDefault(const Constant('receipt_long'))();

  DateTimeColumn get date => dateTime()();

  TextColumn get transactionId => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// What each member owes on one expense, stored rather than divided at read
/// time — see [ExpenseShare].
///
/// No `deletedAt`: a share has no life of its own. It goes when its expense
/// goes, which the reads express by ignoring the shares of a deleted expense,
/// so undeleting the expense brings its split back untouched.
@DataClassName('ExpenseShareRow')
@TableIndex(name: 'expense_shares_expense', columns: {#sharedExpenseId})
@TableIndex(name: 'expense_shares_member', columns: {#memberId})
class ExpenseShares extends Table {
  TextColumn get id => text()();

  TextColumn get sharedExpenseId => text()();

  TextColumn get memberId => text()();

  IntColumn get amountMinor => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// One member paying another back. Append-only — see [Settlement].
@DataClassName('SettlementRow')
@TableIndex(name: 'settlements_group', columns: {#groupId, #recordedAt})
class Settlements extends Table {
  TextColumn get id => text()();

  TextColumn get groupId => text()();

  TextColumn get fromMemberId => text()();

  TextColumn get toMemberId => text()();

  IntColumn get amountMinor => integer()();

  IntColumn get method => intEnum<SettlementMethod>()();

  TextColumn get note => text().nullable()();

  DateTimeColumn get recordedAt => dateTime()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
