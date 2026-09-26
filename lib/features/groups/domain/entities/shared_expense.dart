import 'package:freezed_annotation/freezed_annotation.dart';

part 'shared_expense.freezed.dart';

/// How the people on an expense were chosen (§6.14). Persisted by index —
/// append only.
///
/// This records *why* the shares look the way they do; it never decides what
/// they are at read time. The shares themselves are always materialised rows
/// (§5.1), so changing this enum later cannot silently re-split money that
/// has already been agreed.
enum SplitMode {
  equally('Equally'),
  onlyMe('Only me'),
  custom('Custom');

  const SplitMode(this.label);

  final String label;
}

/// One expense somebody paid for the group.
@freezed
abstract class SharedExpense with _$SharedExpense {
  const factory SharedExpense({
    required String id,
    required String groupId,
    required String label,

    /// Minor units, the way every other amount in the app is stored.
    required int amountMinor,
    required String paidByMemberId,
    required DateTime date,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(SplitMode.equally) SplitMode splitMode,
    @Default('receipt_long') String iconKey,

    /// The Finance transaction this expense also wrote, if any. Null in v1:
    /// a shared expense is money moved between friends, not household
    /// spending, and §6.14 never asks for one. The column is §5.1's.
    String? transactionId,
    DateTime? deletedAt,
  }) = _SharedExpense;

  const SharedExpense._();

  bool get isDeleted => deletedAt != null;
}

/// What one member owes on one expense.
///
/// Materialised rather than divided at read time (§5.1): an equal split of
/// ₹1,000 three ways cannot be written as three equal numbers of paise, so
/// the remainder has to land somewhere and stay there. Recomputing it on
/// every read would risk two screens rounding the same expense differently.
@freezed
abstract class ExpenseShare with _$ExpenseShare {
  const factory ExpenseShare({
    required String id,
    required String sharedExpenseId,
    required String memberId,
    required int amountMinor,
  }) = _ExpenseShare;

  const ExpenseShare._();
}

/// Fields a caller supplies to record an expense; the repository fills in the
/// id, the timestamps and the share rows.
class NewSharedExpense {
  const NewSharedExpense({
    required this.label,
    required this.amountMinor,
    required this.paidByMemberId,
    required this.memberIds,
    this.splitMode = SplitMode.equally,
    this.iconKey = 'receipt_long',
    this.date,

    /// Explicit per-member amounts. When null the amount is split equally
    /// across [memberIds]; when given it must sum to [amountMinor], which the
    /// repository checks rather than trusts.
    this.customShares,
  });

  final String label;
  final int amountMinor;
  final String paidByMemberId;

  /// Who the expense is split between, in the group's own member order.
  final List<String> memberIds;
  final SplitMode splitMode;
  final String iconKey;
  final DateTime? date;
  final Map<String, int>? customShares;
}

/// Splits [amountMinor] across [memberIds] so the parts sum to exactly the
/// whole.
///
/// The remainder is handed out one minor unit at a time, to the first members
/// in the list. ₹1,000 across three people is 333.34 / 333.33 / 333.33 rather
/// than three amounts that quietly lose a paisa — and because the order is the
/// group's own member order, the same expense always splits the same way.
///
/// The extra paisa landing on the first member is arbitrary but has to land
/// somewhere; what matters is that it is deterministic and that the shares add
/// up, which is what makes the ledger balance to zero.
Map<String, int> splitEqually(int amountMinor, List<String> memberIds) {
  if (memberIds.isEmpty) return const <String, int>{};

  final base = amountMinor ~/ memberIds.length;
  var remainder = amountMinor - base * memberIds.length;
  final shares = <String, int>{};
  for (final memberId in memberIds) {
    // A negative amount (a refund) leaves a negative remainder, so the extra
    // unit is taken from the first members rather than given to them.
    final extra = remainder == 0 ? 0 : (remainder > 0 ? 1 : -1);
    shares[memberId] = base + extra;
    remainder -= extra;
  }
  return shares;
}
