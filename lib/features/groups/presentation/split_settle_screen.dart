import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/widgets.dart';
import '../domain/entities/group.dart';
import '../domain/entities/group_member.dart';
import '../domain/ledger.dart';
import 'controllers/group_providers.dart';
import 'group_actions.dart';
import 'group_labels.dart';
import 'widgets/add_member_sheet.dart';
import 'widgets/member_avatar.dart';
import 'widgets/shared_expense_sheet.dart';

/// Split & settle up (Appendix A): where everyone stands, and the shortest
/// list of payments that squares it.
class SplitSettleScreen extends ConsumerWidget {
  const SplitSettleScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupByIdProvider(groupId));
    final members = ref.watch(groupMembersProvider(groupId)).value ?? const [];
    final ledger = ref.watch(groupLedgerProvider(groupId));

    return Scaffold(
      appBar: AppBar(
        title: Text(group.value?.name ?? 'Split & settle'),
        actions: [
          IconButton(
            tooltip: 'Add someone',
            icon: const Icon(Symbols.person_add_rounded),
            onPressed: () => unawaited(
              showAddMemberSheet(context, groupId: groupId),
            ),
          ),
        ],
      ),
      body: group.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(KoshaSpace.screen),
          child: SkeletonList(),
        ),
        error: (_, _) => EmptyState(
          icon: Symbols.error_rounded,
          title: "Couldn't load this group",
          body: 'Something went wrong reading the database.',
          actionLabel: 'Try again',
          onAction: () => ref.invalidate(groupByIdProvider(groupId)),
        ),
        data: (loaded) => loaded == null
            ? const EmptyState(
                icon: Symbols.group_rounded,
                title: 'This group is gone',
                body: 'It was deleted. Undo from the toast brings it back.',
              )
            : _Body(
                group: loaded,
                members: members,
                ledger: ledger.value,
                loading: ledger.isLoading,
              ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.group,
    required this.members,
    required this.ledger,
    required this.loading,
  });

  final Group group;
  final List<GroupMember> members;
  final Ledger? ledger;
  final bool loading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ledger == null) {
      return const Padding(
        padding: EdgeInsets.all(KoshaSpace.screen),
        child: SkeletonList(),
      );
    }
    final self = selfMember(members);
    final yourNet = self == null ? 0 : ledger!.balanceFor(self.id)?.netMinor ?? 0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        KoshaSpace.screen,
        KoshaSpace.md,
        KoshaSpace.screen,
        KoshaSpace.xxxl,
      ),
      children: [
        _SummaryCard(
          group: group,
          yourNetMinor: yourNet,
          totalMinor: ledger!.totalMinor,
        ),
        const SizedBox(height: KoshaSpace.xxl),
        const SectionLabel('Where everyone stands'),
        const SizedBox(height: KoshaSpace.sm),
        for (final balance in ledger!.balances)
          _BalanceBar(
            member: memberById(members, balance.memberId),
            balance: balance,
            // Every bar is drawn against the largest standing in the group,
            // so the widest one is full and the rest are honestly relative.
            widestMinor: _widest(ledger!),
          ),
        const SizedBox(height: KoshaSpace.xxl),
        const SectionLabel('Simplest way to settle'),
        const SizedBox(height: KoshaSpace.sm),
        if (ledger!.isSquare)
          const EmptyState(
            icon: Symbols.check_circle_rounded,
            title: "Everyone's square",
            body: 'Nobody owes anybody anything right now.',
          )
        else
          for (final transfer in ledger!.transfers)
            Padding(
              padding: const EdgeInsets.only(bottom: KoshaSpace.sm),
              child: _TransferRow(
                transfer: transfer,
                members: members,
                onPay: () => unawaited(
                  payTransfer(ref, group.id, transfer, members),
                ),
                onRemind: () => remindAbout(
                  ref,
                  memberName(members, transfer.fromMemberId),
                ),
              ),
            ),
        const SizedBox(height: KoshaSpace.xxl),
        OutlinedButton.icon(
          onPressed: members.isEmpty
              ? null
              : () => unawaited(
                    showSharedExpenseSheet(
                      context,
                      groupId: group.id,
                      members: members,
                    ),
                  ),
          icon: const Icon(Symbols.add_rounded, size: 18),
          label: const Text('Add a shared expense'),
        ),
      ],
    );
  }

  int _widest(Ledger ledger) {
    var widest = 0;
    for (final balance in ledger.balances) {
      final size = balance.netMinor.abs();
      if (size > widest) widest = size;
    }
    return widest;
  }
}

/// Trip name, your own line, and the group total as a pill (Appendix A).
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.group,
    required this.yourNetMinor,
    required this.totalMinor,
  });

  final Group group;
  final int yourNetMinor;
  final int totalMinor;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final dates = _dateLine(group);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.name, style: t.titleMedium),
                    if (dates != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        dates,
                        style: t.bodySmall?.copyWith(color: c.text2),
                      ),
                    ],
                  ],
                ),
              ),
              StatusPill(
                KoshaStatus.active,
                label: '${Money.inr(totalMinor)} in total',
              ),
            ],
          ),
          const SizedBox(height: KoshaSpace.md),
          Text(
            yourStanding(yourNetMinor),
            style: t.titleSmall?.copyWith(
              color: yourNetMinor == 0
                  ? c.text
                  : (yourNetMinor > 0 ? c.success : c.error),
            ),
          ),
        ],
      ),
    );
  }

  String? _dateLine(Group group) {
    final start = group.startsOn;
    final end = group.endsOn;
    if (start == null && end == null) return null;
    if (start != null && end != null) {
      return '${Dates.dayMonth(start)} to ${Dates.dayMonthYear(end)}';
    }
    return Dates.dayMonthYear((start ?? end)!);
  }
}

class _BalanceBar extends StatelessWidget {
  const _BalanceBar({
    required this.member,
    required this.balance,
    required this.widestMinor,
  });

  final GroupMember? member;
  final LedgerBalance balance;
  final int widestMinor;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final tone = balance.isSquare
        ? c.text3
        : (balance.isOwed ? c.success : c.error);
    final name = member == null
        ? 'Someone who left'
        : (member!.isSelf ? 'You' : member!.displayName);

    return Padding(
      padding: const EdgeInsets.only(bottom: KoshaSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (member case final m?) ...[
                MemberAvatar(member: m, size: 28),
                const SizedBox(width: KoshaSpace.sm),
              ],
              Expanded(
                child: Text(
                  name,
                  style: t.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                balance.isSquare
                    ? 'Square'
                    : '${balance.isOwed ? '+' : '−'}'
                        '${Money.inr(balance.netMinor.abs())}',
                style: t.bodySmall?.copyWith(color: tone),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ProgressBar(
            value: widestMinor == 0
                ? 0
                : balance.netMinor.abs() / widestMinor,
            color: tone,
          ),
        ],
      ),
    );
  }
}

class _TransferRow extends StatelessWidget {
  const _TransferRow({
    required this.transfer,
    required this.members,
    required this.onPay,
    required this.onRemind,
  });

  final Transfer transfer;
  final List<GroupMember> members;
  final VoidCallback onPay;
  final VoidCallback onRemind;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final from = memberById(members, transfer.fromMemberId);

    return Container(
      padding: const EdgeInsets.all(KoshaSpace.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        border: Border.all(color: c.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (from case final m?) ...[
                MemberAvatar(member: m, size: 28),
                const SizedBox(width: KoshaSpace.sm),
              ],
              Expanded(
                child: Text(
                  '${memberNameOrYou(members, transfer.fromMemberId)} pays '
                  '${memberNameOrYou(members, transfer.toMemberId)}',
                  style: t.bodyMedium,
                ),
              ),
              const SizedBox(width: KoshaSpace.sm),
              Text(Money.inr(transfer.amountMinor), style: t.titleSmall),
            ],
          ),
          const SizedBox(height: KoshaSpace.sm),
          // Both buttons sit in Expanded because the app's FilledButton and
          // OutlinedButton themes set `minimumSize: Size.fromHeight(...)` --
          // an infinite minimum width, which is right for the full-width
          // buttons a sheet ends with and throws inside an unbounded Row.
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: onRemind,
                  child: const Text('Remind'),
                ),
              ),
              const SizedBox(width: KoshaSpace.sm),
              Expanded(
                child: FilledButton(
                  onPressed: onPay,
                  child: const Text('Pay'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
