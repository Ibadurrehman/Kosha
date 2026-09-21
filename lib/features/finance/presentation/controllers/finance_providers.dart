import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/settings/settings_store.dart';
import '../../../../core/utils/clock.dart';
import '../../data/transaction_category_repository_impl.dart';
import '../../data/transaction_repository_impl.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_category.dart';
import '../../domain/finance_settings.dart';

part 'finance_providers.g.dart';

/// The last 6 transactions — Finance dashboard's "Recent transactions".
const int recentTransactionsLimit = 6;

/// Local midnight of the 1st of [today]'s month.
DateTime monthStart(DateTime today) => DateTime(today.year, today.month);

/// Local midnight of the 1st of the month after [today]'s — the exclusive
/// upper bound for "this month".
DateTime monthEnd(DateTime today) => DateTime(today.year, today.month + 1);

@riverpod
Stream<List<Transaction>> thisMonthTransactions(Ref ref) {
  final today = ref.watch(clockProvider).today();
  return ref
      .watch(transactionRepositoryProvider)
      .watchBetween(monthStart(today), monthEnd(today));
}

@riverpod
Stream<List<Transaction>> recentTransactions(Ref ref) =>
    ref.watch(transactionRepositoryProvider).watchRecent(limit: recentTransactionsLimit);

/// One transaction for the detail screen; emits null once it is deleted.
@riverpod
Stream<Transaction?> transactionById(Ref ref, String id) =>
    ref.watch(transactionRepositoryProvider).watchById(id);

@riverpod
Future<int?> monthlyBudgetMinor(Ref ref) =>
    readMonthlyBudgetMinor(ref.watch(settingsStoreProvider));

/// The user's categories for one side of the ledger, in their own order.
/// Seeded with the prototype's list on first read (see
/// `TransactionCategoryRepository`).
@riverpod
Stream<List<TransactionCategory>> categoriesOfKind(Ref ref, CategoryKind kind) =>
    ref.watch(transactionCategoryRepositoryProvider).watchByKind(kind);

/// The category kind that matches a transaction type, so one picker serves
/// both sides of the New expense sheet's toggle.
CategoryKind categoryKindFor(TransactionType type) =>
    type == TransactionType.income ? CategoryKind.income : CategoryKind.expense;

/// What All transactions is filtered down to. Every field is optional; an
/// empty filter shows the whole month.
class TransactionFilter {
  const TransactionFilter({
    required this.month,
    this.category,
    this.method,
    this.type,
  });

  /// Local midnight of the 1st of the month being shown.
  final DateTime month;
  final String? category;
  final TransactionMethod? method;
  final TransactionType? type;

  bool get isFiltered => category != null || method != null || type != null;

  TransactionFilter copyWith({
    DateTime? month,
    String? category,
    TransactionMethod? method,
    TransactionType? type,
    bool clearCategory = false,
    bool clearMethod = false,
    bool clearType = false,
  }) =>
      TransactionFilter(
        month: month ?? this.month,
        category: clearCategory ? null : (category ?? this.category),
        method: clearMethod ? null : (method ?? this.method),
        type: clearType ? null : (type ?? this.type),
      );

  bool matches(Transaction transaction) {
    if (category != null && transaction.category != category) return false;
    if (method != null && transaction.method != method) return false;
    if (type != null && transaction.type != type) return false;
    return true;
  }
}

/// All transactions' month and filter chips. Kept alive so stepping back into
/// the screen lands where the user left it.
@Riverpod(keepAlive: true)
class TransactionFilterController extends _$TransactionFilterController {
  @override
  TransactionFilter build() =>
      TransactionFilter(month: monthStart(ref.watch(clockProvider).today()));

  void showMonth(DateTime month) =>
      state = state.copyWith(month: DateTime(month.year, month.month));

  void stepMonth(int months) => showMonth(
        DateTime(state.month.year, state.month.month + months),
      );

  /// Tapping the chip that is already on clears it, the way the category
  /// chips in the New expense sheet toggle off.
  void toggleCategory(String category) => state = state.category == category
      ? state.copyWith(clearCategory: true)
      : state.copyWith(category: category);

  void toggleMethod(TransactionMethod method) => state = state.method == method
      ? state.copyWith(clearMethod: true)
      : state.copyWith(method: method);

  void toggleType(TransactionType type) => state = state.type == type
      ? state.copyWith(clearType: true)
      : state.copyWith(type: type);

  void clearFilters() => state = state.copyWith(
        clearCategory: true,
        clearMethod: true,
        clearType: true,
      );
}

/// The filtered month, newest first. The month is filtered in SQL (it is an
/// indexed range); the chips are applied in Dart, because the same stream
/// also feeds the running totals above the list and re-querying per chip
/// would make the totals and the rows disagree for a frame.
@riverpod
Stream<List<Transaction>> filteredTransactions(Ref ref) {
  final filter = ref.watch(transactionFilterControllerProvider);
  return ref
      .watch(transactionRepositoryProvider)
      .watchBetween(filter.month, DateTime(filter.month.year, filter.month.month + 1))
      .map((all) => [for (final tx in all) if (filter.matches(tx)) tx]);
}
