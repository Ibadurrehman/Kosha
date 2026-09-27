import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/theme/kosha_shapes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/entities/group.dart';
import '../controllers/group_providers.dart';
import '../group_actions.dart';
import '../group_labels.dart';
import 'add_member_sheet.dart';
import 'member_avatar.dart';
import 'shared_expense_sheet.dart';

/// The trip group card and its shared-expenses list, as they appear on a
/// space's detail screen (§6.14, Appendix A).
///
/// Shown for any space that has a group, not just Travel: the prototype only
/// ever drew one, but nothing about the card is about travel, and special-
/// casing a space by name would be the app deciding what a group is for.
class TripGroupCard extends ConsumerWidget {
  const TripGroupCard({super.key, required this.spaceId});

  final String spaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupsInSpaceProvider(spaceId));
    final list = groups.value ?? const <Group>[];

    if (groups.isLoading) return const SkeletonList(rows: 1);
    if (list.isEmpty) return _StartOne(spaceId: spaceId);

    return Column(
      children: [
        for (final group in list)
          Padding(
            padding: const EdgeInsets.only(bottom: KoshaSpace.md),
            child: _GroupCard(group: group),
          ),
      ],
    );
  }
}

class _StartOne extends StatelessWidget {
  const _StartOne({required this.spaceId});

  final String spaceId;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(KoshaSpace.md),
      decoration: BoxDecoration(
        color: c.sunk,
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Icon(Symbols.group_rounded, color: c.text2),
          const SizedBox(width: KoshaSpace.md),
          Expanded(
            child: Text(
              'Sharing costs here? Start a group and split them.',
              style: t.bodySmall?.copyWith(color: c.text2),
            ),
          ),
          TextButton(
            onPressed: () =>
                unawaited(showNewGroupSheet(context, spaceId: spaceId)),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends ConsumerWidget {
  const _GroupCard({required this.group});

  final Group group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final members = ref.watch(groupMembersProvider(group.id)).value ?? const [];
    final ledger = ref.watch(groupLedgerProvider(group.id)).value;
    final expenses = ref.watch(groupExpensesProvider(group.id)).value ?? const [];
    final self = selfMember(members);
    final yourNet =
        self == null ? 0 : ledger?.balanceFor(self.id)?.netMinor ?? 0;

    return Container(
      padding: const EdgeInsets.all(KoshaSpace.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(group.name, style: t.titleSmall)),
              IconButton(
                tooltip: 'Add someone',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Symbols.person_add_rounded, size: 20),
                onPressed: () => unawaited(
                  showAddMemberSheet(context, groupId: group.id),
                ),
              ),
            ],
          ),
          const SizedBox(height: KoshaSpace.sm),
          Row(
            children: [
              MemberStack(members: members),
              const Spacer(),
              Text(
                '${Money.inr(ledger?.totalMinor ?? 0)} spent',
                style: t.bodySmall?.copyWith(color: c.text2),
              ),
            ],
          ),
          const SizedBox(height: KoshaSpace.md),
          Text(
            yourStanding(yourNet),
            style: t.bodyMedium?.copyWith(
              color: yourNet == 0 ? c.text2 : (yourNet > 0 ? c.success : c.error),
            ),
          ),
          const SizedBox(height: KoshaSpace.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: members.isEmpty
                      ? null
                      : () => unawaited(
                            showSharedExpenseSheet(
                              context,
                              groupId: group.id,
                              members: members,
                            ),
                          ),
                  child: const Text('Add expense'),
                ),
              ),
              const SizedBox(width: KoshaSpace.sm),
              Expanded(
                child: FilledButton(
                  onPressed: () => context.push(Routes.groupSettle(group.id)),
                  child: const Text('Settle up'),
                ),
              ),
            ],
          ),
          if (expenses.isNotEmpty) ...[
            const SizedBox(height: KoshaSpace.lg),
            Text('Shared expenses', style: t.labelLarge),
            const SizedBox(height: KoshaSpace.sm),
            for (final expense in expenses.take(4))
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(
                      sharedExpenseIcon(expense.iconKey),
                      size: 18,
                      color: c.text2,
                    ),
                    const SizedBox(width: KoshaSpace.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.label,
                            style: t.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${memberNameOrYou(members, expense.paidByMemberId)}'
                            ' paid',
                            style: t.bodySmall?.copyWith(color: c.text3),
                          ),
                        ],
                      ),
                    ),
                    Text(Money.inr(expense.amountMinor), style: t.bodySmall),
                    IconButton(
                      tooltip: 'Delete ${expense.label}',
                      visualDensity: VisualDensity.compact,
                      icon: Icon(Symbols.close_rounded, size: 18, color: c.text3),
                      onPressed: () =>
                          unawaited(deleteSharedExpense(ref, expense)),
                    ),
                  ],
                ),
              ),
            if (expenses.length > 4)
              Text(
                '+${expenses.length - 4} more on Settle up',
                style: t.bodySmall?.copyWith(color: c.text3),
              ),
          ],
        ],
      ),
    );
  }
}
