import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/clock.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/widgets.dart';
import '../../bills/domain/entities/bill.dart';
import '../../bills/presentation/bill_labels.dart';
import '../../bills/presentation/controllers/bill_providers.dart';
import '../domain/entities/transaction.dart';
import '../domain/entities/transaction_category.dart';
import 'controllers/finance_providers.dart';
import 'widgets/monthly_budget_sheet.dart';
import 'widgets/new_expense_sheet.dart';
import 'widgets/transaction_row.dart';

/// Finance dashboard (section 6.6): this month, spending by category, the
/// last few transactions, and what bills are coming.
class FinanceScreen extends ConsumerWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(clockProvider).today();
    final monthTransactions = ref.watch(thisMonthTransactionsProvider);
    final recent = ref.watch(recentTransactionsProvider);
    final monthlyBudget = ref.watch(monthlyBudgetMinorProvider);
    final categories = ref.watch(
      categoriesOfKindProvider(CategoryKind.expense),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance'),
        actions: [
          IconButton(
            tooltip: 'Bills',
            icon: const Icon(Symbols.receipt_long_rounded),
            onPressed: () => context.go(Routes.bills),
          ),
        ],
      ),
      floatingActionButton:
          KoshaFab(onPressed: () => unawaited(showNewExpenseSheet(context))),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            KoshaSpace.screen,
            12,
            KoshaSpace.screen,
            120,
          ),
          children: [
            monthTransactions.when(
              loading: () => const SkeletonList(),
              error: (error, _) => EmptyState(
                icon: Symbols.error_rounded,
                title: "Couldn't load this month",
                body: 'Something went wrong reading the database.',
                actionLabel: 'Try again',
                onAction: () => ref.invalidate(thisMonthTransactionsProvider),
              ),
              data: (transactions) => monthlyBudget.when(
                loading: () => const SkeletonList(),
                error: (_, _) => const SizedBox.shrink(),
                data: (budgetMinor) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ThisMonthCard(
                      today: today,
                      transactions: transactions,
                      budgetMinor: budgetMinor,
                      onSetBudget: () =>
                          unawaited(showMonthlyBudgetSheet(context)),
                    ),
                    const SizedBox(height: 26),
                    _CategoryBarsSection(transactions: transactions),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 26),
            const _UpcomingBillsCard(),
            const SizedBox(height: 26),
            _RecentTransactionsSection(
              recent: recent,
              categories: categories.value ?? const [],
              onSeeAll: () => context.go(Routes.transactions),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThisMonthCard extends StatelessWidget {
  const _ThisMonthCard({
    required this.today,
    required this.transactions,
    required this.budgetMinor,
    required this.onSetBudget,
  });

  final DateTime today;
  final List<Transaction> transactions;
  final int? budgetMinor;
  final VoidCallback onSetBudget;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    final expenseMinor = transactions
        .where((tx) => tx.type == TransactionType.expense)
        .fold<int>(0, (sum, tx) => sum + tx.amountMinor);
    final incomeMinor = transactions
        .where((tx) => tx.type == TransactionType.income)
        .fold<int>(0, (sum, tx) => sum + tx.amountMinor);
    // ADR 0006 (D4): fall back to the monthly-budget setting only once the
    // month has no income transaction of its own, and label it "Budgeted"
    // so the two are never confused for an actual figure.
    final hasIncome = incomeMinor > 0;
    final displayIncomeMinor = hasIncome ? incomeMinor : (budgetMinor ?? 0);
    final remainingMinor = displayIncomeMinor - expenseMinor;
    final percentSpent =
        displayIncomeMinor <= 0 ? 0.0 : expenseMinor / displayIncomeMinor;
    final daysInMonth = DateTime(today.year, today.month + 1, 0).day;
    final dayProgress = today.day / daysInMonth;

    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        side: BorderSide(color: c.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatColumn(
                    label: hasIncome ? 'Income' : 'Budgeted',
                    value: Money.inr(displayIncomeMinor),
                    color: c.success,
                  ),
                ),
                Expanded(
                  child: _StatColumn(
                    label: 'Expenses',
                    value: Money.inr(expenseMinor),
                    color: c.error,
                  ),
                ),
                Expanded(
                  child: _StatColumn(
                    label: 'Remaining',
                    // Money.inr always renders a positive magnitude, so an
                    // overspent month needs its own sign or it would read as
                    // money still left.
                    value: remainingMinor < 0
                        ? '-${Money.inr(remainingMinor)}'
                        : Money.inr(remainingMinor),
                    color: remainingMinor < 0 ? c.error : c.text,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ProgressBar(
              value: percentSpent,
              color: percentSpent > 1 ? c.error : c.accent,
            ),
            const SizedBox(height: 6),
            Text(
              '${(percentSpent * 100).clamp(0, 999).round()}% spent · '
              'day ${today.day} of $daysInMonth',
              style: t.bodySmall?.copyWith(color: c.text3),
            ),
            const SizedBox(height: 4),
            ProgressBar(value: dayProgress, color: c.text3, height: 3),
            const SizedBox(height: 2),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: onSetBudget,
                child: Text(
                  hasIncome
                      ? 'Set monthly budget'
                      : budgetMinor == null || budgetMinor == 0
                          ? 'Set a monthly budget'
                          : 'Change monthly budget',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t.labelSmall?.copyWith(color: c.text3)),
        const SizedBox(height: 2),
        Text(
          value,
          style: t.titleMedium?.copyWith(color: color, fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _CategoryBarsSection extends StatelessWidget {
  const _CategoryBarsSection({required this.transactions});

  final List<Transaction> transactions;

  static const int _maxBars = 6;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final totals = <String, int>{};
    for (final tx in transactions) {
      final category = tx.category;
      if (tx.type != TransactionType.expense || category == null) continue;
      totals[category] = (totals[category] ?? 0) + tx.amountMinor;
    }
    final sorted = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted.take(_maxBars).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(child: SectionLabel('By category')),
            TextButton(
              onPressed: () => context.go(Routes.categories),
              child: const Text('Manage'),
            ),
          ],
        ),
        if (top.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No expenses logged this month yet.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.text3),
            ),
          )
        else ...[
          for (final entry in top)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _CategoryBar(
                label: entry.key,
                amountMinor: entry.value,
                fraction: entry.value / top.first.value,
              ),
            ),
        ],
      ],
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({
    required this.label,
    required this.amountMinor,
    required this.fraction,
  });

  final String label;
  final int amountMinor;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: t.bodyMedium)),
            Text(Money.inr(amountMinor), style: t.bodyMedium),
          ],
        ),
        const SizedBox(height: 4),
        ProgressBar(value: fraction),
      ],
    );
  }
}

/// Appendix A's "Upcoming bills card → Bills". Overdue bills lead, because
/// they are the ones the user has to act on.
class _UpcomingBillsCard extends ConsumerWidget {
  const _UpcomingBillsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final today = ref.watch(clockProvider).today();
    final upcoming = ref.watch(upcomingBillsProvider).value ?? UpcomingBills.empty;
    final preview = upcoming.bills.take(upcomingBillsPreviewCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(child: SectionLabel('Upcoming bills')),
            TextButton(
              onPressed: () => context.go(Routes.bills),
              child: const Text('See all'),
            ),
          ],
        ),
        Material(
          color: c.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KoshaRadius.card),
            side: BorderSide(color: c.border),
          ),
          child: InkWell(
            onTap: () => context.go(Routes.bills),
            borderRadius: BorderRadius.circular(KoshaRadius.card),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: preview.isEmpty
                  ? Row(
                      children: [
                        IconTile(
                          Symbols.check_circle_rounded,
                          color: c.success,
                          background: c.successSoft,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Nothing due in the next '
                            '$upcomingBillsWindowDays days.',
                            style: t.bodyMedium,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${upcoming.count} '
                                '${upcoming.count == 1 ? 'bill' : 'bills'} '
                                'in the next $upcomingBillsWindowDays days',
                                style: t.bodySmall?.copyWith(color: c.text3),
                              ),
                            ),
                            Text(
                              Money.inr(upcoming.totalMinor),
                              style: t.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        for (final bill in preview)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    bill.name,
                                    style: t.bodyMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                StatusPill(
                                  billPillStatus(billStatus(bill, today)),
                                  label: billBadgeLabel(bill, today),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentTransactionsSection extends StatelessWidget {
  const _RecentTransactionsSection({
    required this.recent,
    required this.categories,
    required this.onSeeAll,
  });

  final AsyncValue<List<Transaction>> recent;
  final List<TransactionCategory> categories;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(child: SectionLabel('Recent transactions')),
            TextButton(onPressed: onSeeAll, child: const Text('See all')),
          ],
        ),
        recent.when(
          loading: () => const SkeletonList(rows: 3),
          error: (error, _) => const SizedBox.shrink(),
          data: (transactions) => transactions.isEmpty
              ? const EmptyState(
                  icon: Symbols.account_balance_wallet_rounded,
                  title: 'No transactions yet',
                  body: 'Tap the + button to log your first expense.',
                )
              : Column(
                  children: [
                    for (final tx in transactions)
                      TransactionRow(
                        transaction: tx,
                        iconKey: _iconKeyFor(tx),
                        onTap: () => context.go(Routes.transactionDetail(tx.id)),
                      ),
                  ],
                ),
        ),
      ],
    );
  }

  String? _iconKeyFor(Transaction transaction) {
    for (final category in categories) {
      if (category.name == transaction.category) return category.iconKey;
    }
    return null;
  }
}
