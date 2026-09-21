import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/widgets.dart';
import '../../bills/presentation/controllers/bill_providers.dart';
import '../domain/entities/transaction.dart';
import 'controllers/finance_providers.dart';
import 'transaction_actions.dart';
import 'transaction_labels.dart';

/// Everything about one transaction: the amount, its fields, the bill it
/// settled if it came from one, and the actions along the bottom.
class TransactionDetailScreen extends ConsumerWidget {
  const TransactionDetailScreen({super.key, required this.transactionId});

  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transaction = ref.watch(transactionByIdProvider(transactionId));

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction')),
      body: transaction.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(KoshaSpace.screen),
          child: SkeletonList(),
        ),
        error: (error, _) => EmptyState(
          icon: Symbols.error_rounded,
          title: "Couldn't load this transaction",
          body: 'Something went wrong reading the database.',
          actionLabel: 'Try again',
          onAction: () => ref.invalidate(transactionByIdProvider(transactionId)),
        ),
        data: (value) => value == null
            ? EmptyState(
                icon: Symbols.delete_rounded,
                title: 'This transaction is gone',
                body: 'It was deleted. Undo from the message on the list to '
                    'bring it back.',
                actionLabel: 'Back to Finance',
                onAction: () => context.go(Routes.finance),
              )
            : _Detail(transaction: value),
      ),
    );
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final isIncome = transaction.type == TransactionType.income;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              KoshaSpace.screen,
              8,
              KoshaSpace.screen,
              24,
            ),
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      '${isIncome ? '+' : '−'}'
                      '${Money.inrExact(transaction.amountMinor)}',
                      style: t.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isIncome ? c.success : c.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      transactionTitle(transaction),
                      style: t.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _Fields(transaction: transaction),
              if (transaction.billId != null) ...[
                const SizedBox(height: 20),
                const SectionLabel('Paid towards'),
                _LinkedBill(billId: transaction.billId!),
              ],
            ],
          ),
        ),
        _BottomBar(transaction: transaction),
      ],
    );
  }
}

class _Fields extends StatelessWidget {
  const _Fields({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final method = transaction.method;

    final fields = <(IconData, String, String)>[
      (
        Symbols.swap_horiz_rounded,
        'Type',
        transaction.type == TransactionType.income ? 'Income' : 'Expense',
      ),
      (Symbols.event_rounded, 'Date', Dates.dayMonthYear(transaction.date)),
      (Symbols.folder_rounded, 'Category', transaction.category ?? 'Uncategorised'),
      (
        Symbols.credit_card_rounded,
        'Method',
        method == null ? 'Not recorded' : methodLabel(method),
      ),
      (
        Symbols.sticky_note_2_rounded,
        'Note',
        transaction.note?.isNotEmpty ?? false ? transaction.note! : 'None',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(KoshaRadius.card),
      ),
      child: Column(
        children: [
          for (final (index, field) in fields.indexed) ...[
            if (index > 0) Divider(height: 1, color: c.hair),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(field.$1, size: 19, color: c.text3),
                  const SizedBox(width: 12),
                  Expanded(child: Text(field.$2, style: t.bodySmall)),
                  Flexible(
                    child: Text(
                      field.$3,
                      style: t.titleSmall,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The bill this expense settled. A payment can outlive nothing here — if the
/// bill was deleted the row simply says so rather than offering a dead tap.
class _LinkedBill extends ConsumerWidget {
  const _LinkedBill({required this.billId});

  final String billId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bill = ref.watch(billByIdProvider(billId));
    final c = context.kosha;
    return bill.when(
      loading: () => const SizedBox(height: 56),
      error: (_, _) => const SizedBox.shrink(),
      data: (value) => value == null
          ? Text(
              'That bill has since been deleted.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.text3),
            )
          : ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const IconTile(Symbols.receipt_long_rounded),
              title: Text(value.name),
              subtitle: Text(Money.inr(value.amountMinor)),
              trailing: const Icon(Symbols.chevron_right_rounded),
              onTap: () => context.go(Routes.billDetail(value.id)),
            ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () =>
                      context.go(Routes.transactionEdit(transaction.id)),
                  icon: const Icon(Symbols.edit_rounded, size: 20),
                  label: const Text('Edit'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Delete',
                color: c.error,
                icon: const Icon(Symbols.delete_rounded),
                onPressed: () => unawaited(_deleteAndLeave(context, ref)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteAndLeave(BuildContext context, WidgetRef ref) async {
    final deleted =
        await confirmAndDeleteTransaction(context, ref, transaction);
    if (deleted && context.mounted) context.go(Routes.finance);
  }
}
