import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/clock.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/widgets.dart';
import '../../tasks/domain/entities/task.dart';
import '../../tasks/presentation/controllers/task_providers.dart';
import '../../tasks/presentation/task_actions.dart';
import '../../tasks/presentation/widgets/new_task_sheet.dart';
import '../../tasks/presentation/widgets/task_row.dart';

/// The dashboard. Week 1 ships the greeting and the Today section; Needs
/// attention, Upcoming, Quick access and Recent follow in week 3.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clock = ref.watch(clockProvider);
    final now = clock.now();
    final tasks = ref.watch(todayTasksProvider);

    return Scaffold(
      floatingActionButton:
          KoshaFab(onPressed: () => unawaited(showNewTaskSheet(context))),
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
            _Greeting(now: now),
            const SizedBox(height: 26),
            tasks.when(
              loading: () => const SkeletonList(),
              error: (error, _) => EmptyState(
                icon: Symbols.error_rounded,
                title: "Couldn't load today",
                body: 'Something went wrong reading the database.',
                actionLabel: 'Try again',
                onAction: () => ref.invalidate(todayTasksProvider),
              ),
              data: (list) =>
                  _TodaySection(tasks: list, today: clock.today()),
            ),
          ],
        ),
      ),
    );
  }
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
