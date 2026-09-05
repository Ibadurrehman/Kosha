import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/clock.dart';
import '../../../shared/widgets/widgets.dart';
import '../domain/entities/task.dart';
import 'controllers/task_providers.dart';
import 'task_actions.dart';
import 'widgets/new_task_sheet.dart';
import 'widgets/task_row.dart';

/// The five task tabs: Inbox, Today, Upcoming, Overdue and Completed.
class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bucket = ref.watch(selectedTaskBucketProvider);
    final tasks = ref.watch(tasksInBucketProvider(bucket));
    final today = ref.watch(clockProvider).today();

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      floatingActionButton:
          KoshaFab(onPressed: () => unawaited(showNewTaskSheet(context))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              KoshaSpace.screen,
              0,
              KoshaSpace.screen,
              14,
            ),
            child: SegmentedTabs(
              labels: [for (final b in TaskBucket.values) b.label],
              selectedIndex: TaskBucket.values.indexOf(bucket),
              onChanged: (i) => ref
                  .read(selectedTaskBucketProvider.notifier)
                  .select(TaskBucket.values[i]),
            ),
          ),
          Expanded(
            child: tasks.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(horizontal: KoshaSpace.screen),
                child: SkeletonList(),
              ),
              error: (error, _) => EmptyState(
                icon: Symbols.error_rounded,
                title: "Couldn't load your tasks",
                body: 'Something went wrong reading the database.',
                actionLabel: 'Try again',
                onAction: () => ref.invalidate(tasksInBucketProvider(bucket)),
              ),
              data: (list) => list.isEmpty
                  ? _EmptyBucket(bucket: bucket)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        KoshaSpace.screen,
                        0,
                        KoshaSpace.screen,
                        120,
                      ),
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 9),
                      itemBuilder: (_, i) => TaskRow(
                        task: list[i],
                        today: today,
                        onToggle: () => unawaited(toggleTask(ref, list[i])),
                        onOpen: () =>
                            context.go(Routes.taskDetail(list[i].id)),
                        onActions: () => unawaited(
                          openTaskActions(context, ref, list[i]),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBucket extends StatelessWidget {
  const _EmptyBucket({required this.bucket});

  final TaskBucket bucket;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, String title, String body) = switch (bucket) {
      TaskBucket.inbox => (
          Symbols.inbox_rounded,
          'Your inbox is empty',
          'Anything you capture without a date waits here.',
        ),
      TaskBucket.today => (
          Symbols.task_alt_rounded,
          'Nothing planned for today',
          "You're all caught up.",
        ),
      TaskBucket.upcoming => (
          Symbols.calendar_month_rounded,
          'Nothing coming up',
          'Tasks with a future date show here.',
        ),
      TaskBucket.overdue => (
          Symbols.schedule_rounded,
          'Nothing overdue',
          "You're on top of everything.",
        ),
      TaskBucket.completed => (
          Symbols.check_circle_rounded,
          'Nothing completed yet',
          'Finished tasks collect here.',
        ),
    };
    return EmptyState(
      icon: icon,
      title: title,
      body: body,
      actionLabel: bucket == TaskBucket.completed ? null : 'Add task',
      onAction: bucket == TaskBucket.completed
          ? null
          : () => unawaited(showNewTaskSheet(context)),
    );
  }
}
