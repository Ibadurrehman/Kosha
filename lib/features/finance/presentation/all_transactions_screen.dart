import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/clock.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/widgets.dart';
import '../domain/entities/transaction.dart';
import '../domain/entities/transaction_category.dart';
import 'controllers/finance_providers.dart';
import 'transaction_labels.dart';
import 'widgets/new_expense_sheet.dart';
import 'widgets/transaction_row.dart';

final DateFormat _monthTitle = DateFormat('MMMM yyyy');

/// Every transaction in one month, filtered by category, method and type,
/// grouped by day (section 6.6's "All transactions").
class AllTransactionsScreen extends ConsumerWidget {
  const AllTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(transactionFilterControllerProvider);
    final transactions = ref.watch(filteredTransactionsProvider);
    final controller = ref.read(transactionFilterControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All transactions'),
        actions: [
          if (filter.isFiltered)
            TextButton(
              onPressed: controller.clearFilters,
              child: const Text('Clear'),
            ),
        ],
      ),
      floatingActionButton:
          KoshaFab(onPressed: () => unawaited(showNewExpenseSheet(context))),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _MonthBar(month: filter.month),
            const SizedBox(height: 10),
            _Filters(filter: filter),
            const SizedBox(height: 6),
            Expanded(
              child: transactions.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: KoshaSpace.screen),
                  child: SkeletonList(),
                ),
                error: (error, _) => EmptyState(
                  icon: Symbols.error_rounded,
                  title: "Couldn't load transactions",
                  body: 'Something went wrong reading the database.',
                  actionLabel: 'Try again',
                  onAction: () => ref.invalidate(filteredTransactionsProvider),
                ),
                data: (list) => list.isEmpty
                    ? _Empty(isFiltered: filter.isFiltered, onClear: controller.clearFilters)
                    : _GroupedList(transactions: list),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthBar extends ConsumerWidget {
  const _MonthBar({required this.month});

  final DateTime month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final controller = ref.read(transactionFilterControllerProvider.notifier);
    final thisMonth = monthStart(ref.watch(clockProvider).today());
    // Nothing is recorded in the future, so the forward arrow stops at the
    // current month rather than paging through empty screens.
    final canGoForward = month.isBefore(thisMonth);

    return Padding(
      padding: const EdgeInsets.fromLTRB(KoshaSpace.screen, 0, KoshaSpace.screen, 0),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Previous month',
            onPressed: () => controller.stepMonth(-1),
            icon: const Icon(Symbols.chevron_left_rounded),
          ),
          Expanded(
            child: Text(
              _monthTitle.format(month),
              textAlign: TextAlign.center,
              style: t.titleMedium,
            ),
          ),
          IconButton(
            tooltip: 'Next month',
            onPressed: canGoForward ? () => controller.stepMonth(1) : null,
            icon: const Icon(Symbols.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}

class _Filters extends ConsumerWidget {
  const _Filters({required this.filter});

  final TransactionFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(transactionFilterControllerProvider.notifier);
    // Which categories to offer follows the type chip: filtering to income
    // and then being shown "Groceries" would be a chip that can only ever
    // return nothing.
    final categories = ref.watch(
      categoriesOfKindProvider(
        filter.type == null ? CategoryKind.expense : categoryKindFor(filter.type!),
      ),
    );

    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: KoshaSpace.screen),
        children: [
          for (final type in TransactionType.values) ...[
            KoshaChip(
              label: type == TransactionType.expense ? 'Expenses' : 'Income',
              selected: filter.type == type,
              onTap: () => controller.toggleType(type),
            ),
            const SizedBox(width: 8),
          ],
          for (final method in TransactionMethod.values) ...[
            KoshaChip(
              label: methodLabel(method),
              selected: filter.method == method,
              onTap: () => controller.toggleMethod(method),
            ),
            const SizedBox(width: 8),
          ],
          ...categories.maybeWhen(
            data: (list) => [
              for (final category in list) ...[
                KoshaChip(
                  label: category.name,
                  selected: filter.category == category.name,
                  onTap: () => controller.toggleCategory(category.name),
                ),
                const SizedBox(width: 8),
              ],
            ],
            orElse: () => const <Widget>[],
          ),
        ],
      ),
    );
  }
}

/// The month's rows under one date header each, with the day's net beside it.
class _GroupedList extends StatelessWidget {
  const _GroupedList({required this.transactions});

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    final byDay = <DateTime, List<Transaction>>{};
    for (final transaction in transactions) {
      final day = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );
      (byDay[day] ??= []).add(transaction);
    }
    final days = byDay.keys.toList()..sort((a, b) => b.compareTo(a));

    final expenseMinor = transactions
        .where((tx) => tx.type == TransactionType.expense)
        .fold<int>(0, (sum, tx) => sum + tx.amountMinor);
    final incomeMinor = transactions
        .where((tx) => tx.type == TransactionType.income)
        .fold<int>(0, (sum, tx) => sum + tx.amountMinor);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        KoshaSpace.screen,
        4,
        KoshaSpace.screen,
        120,
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${transactions.length} '
                '${transactions.length == 1 ? 'transaction' : 'transactions'}',
                style: t.bodySmall?.copyWith(color: c.text3),
              ),
            ),
            if (incomeMinor > 0) ...[
              Text(
                '+${Money.inr(incomeMinor)}',
                style: t.bodySmall?.copyWith(color: c.success),
              ),
              const SizedBox(width: 10),
            ],
            Text(
              '−${Money.inr(expenseMinor)}',
              style: t.bodySmall?.copyWith(color: c.text2),
            ),
          ],
        ),
        const SizedBox(height: 6),
        for (final day in days) ...[
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 2),
            child: Text(
              Dates.dayMonthYear(day),
              style: t.labelMedium?.copyWith(color: c.text3),
            ),
          ),
          for (final transaction in byDay[day]!)
            _Row(transaction: transaction),
        ],
      ],
    );
  }
}

class _Row extends ConsumerWidget {
  const _Row({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) => TransactionRow(
        transaction: transaction,
        showDate: false,
        // `push`, not `go`, on purpose. Transaction detail is a *sibling* of
        // this screen under `/home/finance`, so `go` rebuilds the branch
        // stack as Finance → detail and Back skips this list entirely. Found
        // by driving the real screens (§12.3.2). Finance's own Recent list
        // still uses `go`, because there Back should land on Finance.
        onTap: () => context.push(Routes.transactionDetail(transaction.id)),
      );
}

class _Empty extends StatelessWidget {
  const _Empty({required this.isFiltered, required this.onClear});

  final bool isFiltered;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => isFiltered
      ? EmptyState(
          icon: Symbols.search_off_rounded,
          title: 'Nothing matches those filters',
          body: 'Try a different category, method or month.',
          actionLabel: 'Clear filters',
          onAction: onClear,
        )
      : EmptyState(
          icon: Symbols.account_balance_wallet_rounded,
          title: 'Nothing this month',
          body: 'Transactions you log will be listed here, newest first.',
          actionLabel: 'Add expense',
          onAction: () => unawaited(showNewExpenseSheet(context)),
        );
}
