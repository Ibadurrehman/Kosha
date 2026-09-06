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
import '../../finance/presentation/transaction_labels.dart';
import '../domain/entities/bill.dart';
import '../domain/entities/payment.dart';
import 'bill_actions.dart';
import 'bill_labels.dart';
import 'controllers/bill_providers.dart';

/// Everything about one bill: status, its fields, the payment history, and
/// the actions along the bottom (section 6.7).
class BillDetailScreen extends ConsumerWidget {
  const BillDetailScreen({super.key, required this.billId});

  final String billId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bill = ref.watch(billByIdProvider(billId));

    return Scaffold(
      appBar: AppBar(title: const Text('Bill')),
      body: bill.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(KoshaSpace.screen),
          child: SkeletonList(),
        ),
        error: (error, _) => EmptyState(
          icon: Symbols.error_rounded,
          title: "Couldn't load this bill",
          body: 'Something went wrong reading the database.',
          actionLabel: 'Try again',
          onAction: () => ref.invalidate(billByIdProvider(billId)),
        ),
        data: (value) => value == null
            ? EmptyState(
                icon: Symbols.delete_rounded,
                title: 'This bill is gone',
                body: 'It was deleted. Undo from the message on the list to '
                    'bring it back.',
                actionLabel: 'Back to bills',
                onAction: () => context.go(Routes.bills),
              )
            : _Detail(bill: value),
      ),
    );
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.bill});

  final Bill bill;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final today = ref.watch(clockProvider).today();

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              KoshaSpace.screen,
              4,
              KoshaSpace.screen,
              24,
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: StatusPill(
                  billPillStatus(billStatus(bill, today)),
                  label: billBadgeLabel(bill, today),
                  icon: Symbols.schedule_rounded,
                ),
              ),
              const SizedBox(height: 12),
              Text(bill.name, style: t.headlineSmall),
              const SizedBox(height: 4),
              Text(
                Money.inrExact(bill.amountMinor),
                style: t.titleLarge?.copyWith(
                  color: c.text2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              _Fields(bill: bill),
              if (bill.notes?.isNotEmpty ?? false) ...[
                const SizedBox(height: 20),
                const SectionLabel('Notes'),
                Text(bill.notes!, style: t.bodyMedium?.copyWith(color: c.text2)),
              ],
              const SizedBox(height: 20),
              const SectionLabel('Payment history'),
              _Payments(billId: bill.id),
            ],
          ),
        ),
        _BottomBar(bill: bill),
      ],
    );
  }
}

class _Fields extends StatelessWidget {
  const _Fields({required this.bill});

  final Bill bill;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final due = bill.nextDue;

    final fields = <(IconData, String, String)>[
      (
        Symbols.event_rounded,
        bill.kind == BillKind.subscription ? 'Renews on' : 'Due on',
        due == null ? 'Nothing owed' : Dates.dayMonthYear(due),
      ),
      (Symbols.repeat_rounded, 'Frequency', billFrequencyLabel(bill)),
      (
        Symbols.notifications_rounded,
        'Reminder',
        billReminderLabel(bill.reminderOffsetDays),
      ),
      (
        Symbols.autorenew_rounded,
        'Autopay',
        bill.autopay ? 'On' : 'Off',
      ),
      (Symbols.apartment_rounded, 'Provider', bill.provider ?? 'Not set'),
      (Symbols.badge_rounded, 'Account', bill.accountRef ?? 'Not set'),
      (
        Symbols.check_circle_rounded,
        'Last paid',
        bill.lastPaidOn == null ? 'Never' : Dates.dayMonthYear(bill.lastPaidOn!),
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
                children: [
                  Icon(field.$1, size: 19, color: c.text3),
                  const SizedBox(width: 12),
                  Expanded(child: Text(field.$2, style: t.bodySmall)),
                  Flexible(
                    child: Text(
                      field.$3,
                      style: t.titleSmall,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

class _Payments extends ConsumerWidget {
  const _Payments({required this.billId});

  final String billId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final payments = ref.watch(billPaymentsProvider(billId));

    return payments.when(
      loading: () => const SizedBox(height: 40),
      error: (_, _) => Text('History unavailable', style: t.bodySmall),
      data: (list) => list.isEmpty
          ? Text(
              'Nothing paid yet. "Pay now" records the first one.',
              style: t.bodySmall?.copyWith(color: c.text3),
            )
          : Column(
              children: [
                for (final Payment payment in list)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: IconTile(
                      Symbols.check_circle_rounded,
                      color: c.success,
                      background: c.successSoft,
                    ),
                    title: Text(Money.inr(payment.amountMinor)),
                    subtitle: Text(
                      [
                        Dates.dayMonthYear(payment.paidOn),
                        if (payment.method != null) methodLabel(payment.method!),
                      ].join(' · '),
                    ),
                    trailing: payment.transactionId == null
                        ? null
                        : IconButton(
                            tooltip: 'Open the expense',
                            icon: const Icon(Symbols.open_in_full_rounded, size: 19),
                            onPressed: () => context.go(
                              Routes.transactionDetail(payment.transactionId!),
                            ),
                          ),
                  ),
              ],
            ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({required this.bill});

  final Bill bill;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final canPay = bill.nextDue != null;

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
                  onPressed:
                      canPay ? () => unawaited(payBill(context, ref, bill)) : null,
                  icon: const Icon(Symbols.check_rounded, size: 20),
                  label: Text(bill.autopay ? 'Mark as paid' : 'Pay now'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Edit',
                icon: const Icon(Symbols.edit_rounded),
                onPressed: () => context.go(Routes.billEdit(bill.id)),
              ),
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
    final deleted = await confirmAndDeleteBill(context, ref, bill);
    if (deleted && context.mounted) context.go(Routes.bills);
  }
}
