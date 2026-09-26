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
import '../../../shared/state/toast_controller.dart';
import '../../../shared/widgets/widgets.dart';
import '../../finance/presentation/widgets/transaction_row.dart';
import '../../groups/presentation/widgets/trip_group_card.dart';
import '../../tasks/presentation/task_actions.dart';
import '../../tasks/presentation/widgets/task_row.dart';
import '../data/space_repository_impl.dart';
import '../domain/entities/space.dart';
import '../domain/entities/space_summary.dart';
import 'controllers/space_detail_providers.dart';
import 'controllers/space_providers.dart';
import 'space_icons.dart';
import 'space_labels.dart';
import 'widgets/new_space_sheet.dart';

/// The generic space aggregator (section 6.5): a header, three stats, then
/// every section the space is allowed to hold, each pulling the items whose
/// `space_id` matches.
///
/// Sections appear in the plan's order — Upcoming / Tasks / Budget /
/// Documents / Notes / Lists — but only the ones whose tables exist are built.
/// Documents, Notes and Lists arrive in Phases 3 and 4; a section that could
/// only ever render an empty state would be a promise the app cannot keep.
class SpaceDetailScreen extends ConsumerWidget {
  const SpaceDetailScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final space = ref.watch(spaceByIdProvider(spaceId));

    return Scaffold(
      appBar: AppBar(
        title: Text(space.value?.name ?? 'Space'),
        actions: [
          if (space.value case final loaded?)
            IconButton(
              tooltip: 'Space settings',
              onPressed: () => unawaited(_editSpace(context, ref, loaded)),
              icon: const Icon(Symbols.tune_rounded),
            ),
        ],
      ),
      body: space.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(horizontal: KoshaSpace.screen),
          child: SkeletonList(),
        ),
        error: (error, _) => const EmptyState(
          icon: Symbols.error_rounded,
          title: "Couldn't load this space",
          body: 'Something went wrong reading the database.',
        ),
        data: (loaded) => loaded == null
            ? const EmptyState(
                icon: Symbols.folder_rounded,
                title: 'This space is archived',
                body: 'Bring it back from the Spaces screen to see what is '
                    'inside it.',
              )
            : _SpaceBody(space: loaded),
      ),
    );
  }

  Future<void> _editSpace(
    BuildContext context,
    WidgetRef ref,
    Space space,
  ) async {
    final result = await showNewSpaceSheet(context, space: space);
    if (result == null || !context.mounted) return;

    await ref.read(spaceRepositoryProvider).edit(
          space.id,
          name: result.name,
          iconKey: result.iconKey,
          holds: result.holds,
        );
    if (!context.mounted) return;
    ref.read(toastControllerProvider.notifier).show('Saved');
  }
}

class _SpaceBody extends ConsumerWidget {
  const _SpaceBody({required this.space});

  final Space space;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary =
        ref.watch(spaceSummariesProvider).value?[space.id] ??
            SpaceSummary.empty;
    final tasks = ref.watch(spaceTasksProvider(space.id));
    final transactions = ref.watch(spaceTransactionsProvider(space.id));

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        KoshaSpace.screen,
        0,
        KoshaSpace.screen,
        KoshaSpace.xxxl,
      ),
      children: [
        _Header(space: space),
        const SizedBox(height: KoshaSpace.xl),
        _Stats(summary: summary),
        // The group card sits above the sections: a space that is splitting
        // money with people is about that first, and the per-kind sections
        // below are the space's own items either way.
        const SizedBox(height: KoshaSpace.xxl),
        TripGroupCard(spaceId: space.id),
        if (space.holdsKind(SpaceHolds.tasks)) ...[
          const SizedBox(height: KoshaSpace.xxl),
          const SectionLabel('Tasks'),
          tasks.when(
            loading: () => const SkeletonList(rows: 2),
            error: (_, _) => const _SectionError(),
            data: (list) => list.isEmpty
                ? const _SectionEmpty(
                    text: 'No open tasks filed here.',
                  )
                : Column(
                    children: [
                      for (final task in list)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: TaskRow(
                            task: task,
                            today: ref.watch(clockProvider).today(),
                            onToggle: () => unawaited(toggleTask(ref, task)),
                            onOpen: () =>
                                context.go(Routes.taskDetail(task.id)),
                            onActions: () => unawaited(
                              openTaskActions(context, ref, task),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
        if (space.holdsKind(SpaceHolds.expenses)) ...[
          const SizedBox(height: KoshaSpace.xxl),
          SectionLabel(
            'Money',
            trailing: Text(
              '${Money.inr(summary.spentThisMonthMinor)} this month',
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
          transactions.when(
            loading: () => const SkeletonList(rows: 2),
            error: (_, _) => const _SectionError(),
            data: (list) => list.isEmpty
                ? const _SectionEmpty(
                    text: 'Nothing spent against this space yet.',
                  )
                : Column(
                    children: [
                      for (final transaction in list)
                        TransactionRow(
                          transaction: transaction,
                          onTap: () => context.go(
                            Routes.transactionDetail(transaction.id),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.space});

  final Space space;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: c.accentSoft,
            borderRadius: BorderRadius.circular(KoshaRadius.card),
          ),
          child: Icon(spaceIcon(space.iconKey), color: c.accent),
        ),
        const SizedBox(width: KoshaSpace.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(space.name, style: t.titleLarge),
              const SizedBox(height: 2),
              Text(
                holdsSummary(space.holds),
                style: t.bodySmall?.copyWith(color: c.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({required this.summary});

  final SpaceSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: KoshaSpace.md,
      children: [
        Expanded(
          child: _Stat(
            label: 'Spent',
            value: Money.inr(summary.spentThisMonthMinor),
            caption: 'this month',
          ),
        ),
        Expanded(
          child: _Stat(
            label: 'Open tasks',
            value: '${summary.openTasks}',
            caption: summary.openTasks == 1 ? 'task' : 'tasks',
          ),
        ),
        Expanded(
          child: _Stat(
            label: 'Bills',
            value: '${summary.bills}',
            caption: summary.bills == 1 ? 'bill' : 'bills',
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(KoshaSpace.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        border: Border.all(color: c.hair),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: t.labelSmall?.copyWith(color: c.text3),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: t.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            caption,
            style: t.bodySmall?.copyWith(color: c.text3),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SectionEmpty extends StatelessWidget {
  const _SectionEmpty({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: KoshaSpace.md),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.text3),
      ),
    );
  }
}

class _SectionError extends StatelessWidget {
  const _SectionError();

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: KoshaSpace.md),
      child: Text(
        "Couldn't load this section.",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.error),
      ),
    );
  }
}
