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
import '../domain/entities/bill.dart';
import 'bill_actions.dart';
import 'controllers/bill_providers.dart';
import 'widgets/bill_card.dart';
import 'widgets/new_bill_sheet.dart';

/// Bills and subscriptions: five tabs, the outstanding total, and a card per
/// bill whose actions follow its status (section 6.7).
class BillsScreen extends ConsumerWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(selectedBillTabProvider);
    final bills = ref.watch(billsInTabProvider(tab));
    final outstanding = ref.watch(outstandingBillsMinorProvider);
    final today = ref.watch(clockProvider).today();

    return Scaffold(
      appBar: AppBar(title: const Text('Bills & subscriptions')),
      floatingActionButton:
          KoshaFab(onPressed: () => unawaited(showNewBillSheet(context))),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _OutstandingHeader(outstanding: outstanding),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                KoshaSpace.screen,
                0,
                KoshaSpace.screen,
                12,
              ),
              child: SegmentedTabs(
                labels: [for (final t in BillTab.values) t.label],
                selectedIndex: BillTab.values.indexOf(tab),
                onChanged: (i) => ref
                    .read(selectedBillTabProvider.notifier)
                    .select(BillTab.values[i]),
              ),
            ),
            Expanded(
              child: bills.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: KoshaSpace.screen),
                  child: SkeletonList(),
                ),
                error: (error, _) => EmptyState(
                  icon: Symbols.error_rounded,
                  title: "Couldn't load your bills",
                  body: 'Something went wrong reading the database.',
                  actionLabel: 'Try again',
                  onAction: () => ref.invalidate(billsInTabProvider(tab)),
                ),
                data: (list) => list.isEmpty
                    ? _EmptyTab(tab: tab)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          KoshaSpace.screen,
                          0,
                          KoshaSpace.screen,
                          120,
                        ),
                        itemCount: list.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => BillCard(
                          bill: list[i],
                          today: today,
                          onOpen: () => context.go(Routes.billDetail(list[i].id)),
                          onPay: () => unawaited(payBill(context, ref, list[i])),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutstandingHeader extends StatelessWidget {
  const _OutstandingHeader({required this.outstanding});

  final AsyncValue<int> outstanding;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final total = outstanding.value ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        KoshaSpace.screen,
        4,
        KoshaSpace.screen,
        14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Outstanding',
                  style: t.labelSmall?.copyWith(color: c.text3),
                ),
                const SizedBox(height: 2),
                Text(
                  Money.inr(total),
                  style: t.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: total > 0 ? c.text : c.text2,
                  ),
                ),
              ],
            ),
          ),
          if (total == 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                'Nothing owed',
                style: t.bodySmall?.copyWith(color: c.success),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyTab extends StatelessWidget {
  const _EmptyTab({required this.tab});

  final BillTab tab;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, String title, String body) = switch (tab) {
      BillTab.all => (
          Symbols.receipt_long_rounded,
          'No bills yet',
          'Add the ones you pay every month and Kosha will remind you '
              'before each is due.',
        ),
      BillTab.dueSoon => (
          Symbols.schedule_rounded,
          'Nothing due soon',
          'Bills inside their reminder window show here.',
        ),
      BillTab.overdue => (
          Symbols.check_circle_rounded,
          'Nothing overdue',
          "You're on top of everything.",
        ),
      BillTab.upcoming => (
          Symbols.calendar_month_rounded,
          'Nothing coming up',
          'Bills further out than their reminder window show here.',
        ),
      BillTab.paid => (
          Symbols.savings_rounded,
          'Nothing paid yet',
          'Bills you settle collect here until the next one comes round.',
        ),
    };
    return EmptyState(
      icon: icon,
      title: title,
      body: body,
      actionLabel: tab == BillTab.all ? 'Add bill' : null,
      onAction: tab == BillTab.all
          ? () => unawaited(showNewBillSheet(context))
          : null,
    );
  }
}
