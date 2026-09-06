import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/settings/settings_store.dart';
import '../../../../core/utils/clock.dart';
import '../../data/transaction_repository_impl.dart';
import '../../domain/entities/transaction.dart';
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

@riverpod
Future<int?> monthlyBudgetMinor(Ref ref) =>
    readMonthlyBudgetMinor(ref.watch(settingsStoreProvider));
