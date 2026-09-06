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
import '../../notifications/presentation/controllers/notification_providers.dart';
import '../../quick_add/presentation/quick_add_sheet.dart';
import '../../settings/presentation/customize_dashboard_screen.dart';
import '../../tasks/domain/entities/task.dart';
import '../../tasks/presentation/controllers/task_providers.dart';
import '../../tasks/presentation/task_actions.dart';
import '../../tasks/presentation/widgets/new_task_sheet.dart';
import '../../tasks/presentation/widgets/task_row.dart';
import '../domain/entities/dashboard_section.dart';
import '../domain/entities/needs_attention_item.dart';
import '../domain/entities/recent_item.dart';
import '../domain/entities/upcoming_item.dart';
import 'controllers/home_providers.dart';
import 'home_item_routing.dart';

/// The dashboard: greeting, then whichever of the 5 sections Customize
/// dashboard has left enabled, in the order it left them.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clock = ref.watch(clockProvider);
    final now = clock.now();
    final sections = ref.watch(dashboardSectionsProvider);

    return Scaffold(
      floatingActionButton:
          KoshaFab(onPressed: () => unawaited(showQuickAddSheet(context))),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _Greeting(now: now)),
                IconButton(
                  tooltip: 'Search',
                  icon: const Icon(Symbols.search_rounded),
                  onPressed: () => context.go(Routes.search),
                ),
                const _NotificationBell(),
              ],
            ),
            const SizedBox(height: 12),
            sections.when(
              loading: () => const SkeletonList(),
              error: (error, _) => EmptyState(
                icon: Symbols.error_rounded,
                title: "Couldn't load your dashboard",
                body: 'Something went wrong reading the database.',
                actionLabel: 'Try again',
                onAction: () => ref.invalidate(dashboardSectionsProvider),
              ),
              data: (list) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final section in list.where((s) => s.enabled))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 26),
                      child: _sectionFor(section.key),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionFor(HomeSectionKey key) => switch (key) {
        HomeSectionKey.attention => const _NeedsAttentionSection(),
        HomeSectionKey.today => const _TodaySectionLoader(),
        HomeSectionKey.upcoming => const _UpcomingSection(),
        HomeSectionKey.quickAccess => const _QuickAccessSection(),
        HomeSectionKey.recent => const _RecentSection(),
      };
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final part = switch (now.hour) {
      < 12 => 'morning',
      < 17 => 'afternoon',
      _ => 'evening',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Good $part', style: t.headlineSmall),
        const SizedBox(height: 4),
        Text(Dates.long(now), style: t.bodySmall),
      ],
    );
  }
}

class _NotificationBell extends ConsumerWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final unread = ref.watch(unreadNotificationCountProvider).value ?? 0;
    return IconButton(
      tooltip: 'Notifications',
      onPressed: () => context.go(Routes.notifications),
      icon: Badge(
        isLabelVisible: unread > 0,
        label: Text('$unread'),
        backgroundColor: c.error,
        child: const Icon(Symbols.notifications_rounded),
      ),
    );
  }
}

/// Loads Today's tasks and hands them to [_TodaySection] — split out so
/// [HomeScreen._sectionFor] can return a `const` widget per section key.
class _TodaySectionLoader extends ConsumerWidget {
  const _TodaySectionLoader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clock = ref.watch(clockProvider);
    final tasks = ref.watch(todayTasksProvider);
    return tasks.when(
      loading: () => const SkeletonList(),
      error: (error, _) => EmptyState(
        icon: Symbols.error_rounded,
        title: "Couldn't load today",
        body: 'Something went wrong reading the database.',
        actionLabel: 'Try again',
        onAction: () => ref.invalidate(todayTasksProvider),
      ),
      data: (list) => _TodaySection(tasks: list, today: clock.today()),
    );
  }
}

class _TodaySection extends ConsumerWidget {
  const _TodaySection({required this.tasks, required this.today});

  final List<Task> tasks;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final remaining = tasks.where((task) => !task.done).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(
          'Today',
          trailing: tasks.isEmpty
              ? null
              : Text('$remaining of ${tasks.length} left', style: t.bodySmall),
        ),
        if (tasks.isEmpty)
          EmptyState(
            icon: Symbols.task_alt_rounded,
            title: 'Nothing planned for today',
            body: "You're all caught up.",
            actionLabel: 'Add a task',
            onAction: () => unawaited(showNewTaskSheet(context)),
          )
        else ...[
          for (final task in tasks)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: TaskRow(
                task: task,
                today: today,
                onToggle: () => unawaited(toggleTask(ref, task)),
                onOpen: () => context.go(Routes.taskDetail(task.id)),
                onActions: () =>
                    unawaited(openTaskActions(context, ref, task)),
              ),
            ),
          const SizedBox(height: 2),
          OutlinedButton.icon(
            onPressed: () => unawaited(showNewTaskSheet(context)),
            icon: const Icon(Symbols.add_rounded, size: 19),
            label: const Text('Add a task'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ],
      ],
    );
  }
}

/// Left-border-warning rows for whatever needs the user's attention. Only
/// overdue tasks contribute today; Bills/Documents add their own source in
/// later phases (see `home/domain/needs_attention_source.dart`).
class _NeedsAttentionSection extends ConsumerWidget {
  const _NeedsAttentionSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(needsAttentionProvider);
    return items.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => const SizedBox.shrink(),
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionLabel('Needs attention'),
            for (final item in list)
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: _AttentionRow(item: item),
              ),
          ],
        );
      },
    );
  }
}

class _AttentionRow extends StatelessWidget {
  const _AttentionRow({required this.item});

  final NeedsAttentionItem item;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KoshaRadius.row),
        side: BorderSide(color: c.border),
      ),
      child: InkWell(
        onTap: () => context.go(homeItemRoute(item.kind, item.id)),
        borderRadius: BorderRadius.circular(KoshaRadius.row),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: c.warning, width: 3)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: t.titleSmall),
                    const SizedBox(height: 2),
                    Text(item.subtitle, style: t.bodySmall?.copyWith(color: c.warning)),
                  ],
                ),
              ),
              Text(item.ctaLabel, style: t.labelLarge?.copyWith(color: c.accent)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Date-tile rows for what's due in the next week.
class _UpcomingSection extends ConsumerWidget {
  const _UpcomingSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(upcomingProvider);
    return items.when(
      loading: () => const SkeletonList(rows: 2),
      error: (error, _) => const SizedBox.shrink(),
      data: (list) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionLabel('Upcoming'),
            if (list.isEmpty)
              const EmptyState(
                icon: Symbols.event_repeat_rounded,
                title: 'Nothing coming up',
                body: 'Tasks with a date in the next week show here.',
              )
            else
              for (final item in list)
                Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: _UpcomingRow(item: item),
                ),
          ],
        );
      },
    );
  }
}

class _UpcomingRow extends StatelessWidget {
  const _UpcomingRow({required this.item});

  final UpcomingItem item;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KoshaRadius.row),
        side: BorderSide(color: c.border),
      ),
      child: InkWell(
        onTap: () => context.go(homeItemRoute(item.kind, item.id)),
        borderRadius: BorderRadius.circular(KoshaRadius.row),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          child: Row(
            children: [
              _DateTile(date: item.date),
              const SizedBox(width: 12),
              Expanded(child: Text(item.title, style: t.titleSmall)),
              const StatusPill(KoshaStatus.upcoming),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: c.sunk, borderRadius: BorderRadius.circular(11)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${date.day}', style: t.titleSmall),
          Text(Dates.dayMonth(date).split(' ').last, style: t.labelSmall),
        ],
      ),
    );
  }
}

/// Shortcuts to the screens that exist. Spaces don't (Phase 3), so this shows
/// Tasks/Calendar/Finance/Bills/Customize dashboard rather than "5 most-used
/// spaces".
class _QuickAccessSection extends StatelessWidget {
  const _QuickAccessSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionLabel('Quick access'),
        Row(
          children: [
            Expanded(
              child: _QuickAccessTile(
                icon: Symbols.check_circle_rounded,
                label: 'Tasks',
                onTap: () => context.go(Routes.tasks),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAccessTile(
                icon: Symbols.calendar_month_rounded,
                label: 'Calendar',
                onTap: () => context.go(Routes.calendar),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAccessTile(
                icon: Symbols.account_balance_wallet_rounded,
                label: 'Finance',
                onTap: () => context.go(Routes.finance),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAccessTile(
                icon: Symbols.receipt_long_rounded,
                label: 'Bills',
                onTap: () => context.go(Routes.bills),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAccessTile(
                icon: Symbols.dashboard_customize_rounded,
                label: 'Customize',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const CustomizeDashboardScreen(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAccessTile extends StatelessWidget {
  const _QuickAccessTile({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        side: BorderSide(color: c.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              IconTile(icon),
              const SizedBox(height: 8),
              Text(label, style: t.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}

/// The last 10 created/updated items, newest first.
class _RecentSection extends ConsumerWidget {
  const _RecentSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(recentItemsProvider);
    return items.when(
      loading: () => const SkeletonList(rows: 2),
      error: (error, _) => const SizedBox.shrink(),
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionLabel('Recent'),
            for (final item in list)
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: _RecentRow(item: item),
              ),
          ],
        );
      },
    );
  }
}

class _RecentRow extends StatelessWidget {
  const _RecentRow({required this.item});

  final RecentItem item;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KoshaRadius.row),
        side: BorderSide(color: c.border),
      ),
      child: InkWell(
        onTap: () => context.go(homeItemRoute(item.kind, item.id)),
        borderRadius: BorderRadius.circular(KoshaRadius.row),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: t.titleSmall),
                    const SizedBox(height: 2),
                    Text(item.subtitle, style: t.bodySmall),
                  ],
                ),
              ),
              Text(Dates.dayMonth(item.at), style: t.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}
