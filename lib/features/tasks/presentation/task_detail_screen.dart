import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/router/app_router.dart';
import '../../../core/services/recurrence/recurrence.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/clock.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/widgets.dart';
import '../domain/entities/activity_entry.dart';
import '../domain/entities/task.dart';
import 'controllers/task_providers.dart';
import 'task_actions.dart';
import 'task_labels.dart';

/// Everything about one task: status, description, its seven fields, an
/// expandable history, and the actions along the bottom.
class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  bool _showMore = false;

  @override
  Widget build(BuildContext context) {
    final task = ref.watch(taskByIdProvider(widget.taskId));
    final loaded = switch (task) {
      AsyncData(:final value) => value,
      _ => null,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task'),
        actions: [
          if (loaded != null)
            IconButton(
              icon: const Icon(Symbols.more_horiz_rounded),
              onPressed: () => unawaited(
                openTaskActions(
                  context,
                  ref,
                  loaded,
                  showOpenDetails: false,
                ),
              ),
            ),
        ],
      ),
      body: task.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(KoshaSpace.screen),
          child: SkeletonList(),
        ),
        error: (error, _) => EmptyState(
          icon: Symbols.error_rounded,
          title: "Couldn't load this task",
          body: 'Something went wrong reading the database.',
          actionLabel: 'Try again',
          onAction: () => ref.invalidate(taskByIdProvider(widget.taskId)),
        ),
        data: (value) => value == null
            ? EmptyState(
                icon: Symbols.delete_rounded,
                title: 'This task is gone',
                body: 'It was deleted. Undo from the message on the list to '
                    'bring it back.',
                actionLabel: 'Back to tasks',
                onAction: () => context.go(Routes.tasks),
              )
            : _Detail(
                task: value,
                showMore: _showMore,
                onToggleMore: () => setState(() => _showMore = !_showMore),
              ),
      ),
    );
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({
    required this.task,
    required this.showMore,
    required this.onToggleMore,
  });

  final Task task;
  final bool showMore;
  final VoidCallback onToggleMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final today = ref.watch(clockProvider).today();
    final bucket = task.bucketOn(today);

    final status = task.done
        ? KoshaStatus.done
        : bucket == TaskBucket.overdue
            ? KoshaStatus.overdue
            : KoshaStatus.dueSoon;

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
                  status,
                  label: taskBadgeLabel(task, today),
                  icon: Symbols.schedule_rounded,
                ),
              ),
              const SizedBox(height: 12),
              Text(task.title, style: t.headlineSmall),
              const SizedBox(height: 8),
              Text(
                task.description?.isNotEmpty ?? false
                    ? task.description!
                    : 'No description yet.',
                style: t.bodyMedium?.copyWith(color: c.text2),
              ),
              const SizedBox(height: 20),
              _Fields(task: task),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: onToggleMore,
                icon: Icon(
                  showMore
                      ? Symbols.expand_less_rounded
                      : Symbols.expand_more_rounded,
                ),
                label: Text(showMore ? 'Hide details' : 'Notes and activity'),
              ),
              if (showMore) ...[
                const SizedBox(height: 8),
                const SectionLabel('Notes'),
                Text(
                  task.description?.isNotEmpty ?? false
                      ? task.description!
                      : 'Nothing noted yet. Add a note from Edit.',
                  style: t.bodyMedium?.copyWith(color: c.text2),
                ),
                const SizedBox(height: 20),
                const SectionLabel('Activity'),
                _Activity(taskId: task.id),
              ],
            ],
          ),
        ),
        _BottomBar(task: task),
      ],
    );
  }
}

class _Fields extends StatelessWidget {
  const _Fields({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final due = task.dueDate;
    final minutes = task.dueMinutes;

    final fields = <(IconData, String, String)>[
      (
        Symbols.event_rounded,
        'Due date',
        due == null ? 'Not set' : Dates.dayMonthYear(due),
      ),
      (
        Symbols.schedule_rounded,
        'Time',
        minutes == null ? 'Any time' : Dates.minuteOfDay(minutes),
      ),
      (Symbols.flag_rounded, 'Priority', task.priority.label),
      (
        Symbols.repeat_rounded,
        'Repeat',
        Recurrence.label(task.recurrenceRule),
      ),
      (
        Symbols.notifications_rounded,
        'Reminder',
        reminderLabel(task.reminderOffsetMinutes),
      ),
      (Symbols.folder_rounded, 'Category', task.category ?? 'Inbox'),
      (
        Symbols.check_circle_rounded,
        'Status',
        task.done ? 'Completed' : 'Open',
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
                  Text(field.$3, style: t.titleSmall),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Activity extends ConsumerWidget {
  const _Activity({required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final entries = ref.watch(taskActivityProvider(taskId));

    return entries.when(
      loading: () => const SizedBox(height: 40),
      error: (_, _) => Text('History unavailable', style: t.bodySmall),
      data: (list) => list.isEmpty
          ? Text('Nothing recorded yet.', style: t.bodySmall)
          : Column(
              children: [
                for (final ActivityEntry entry in list)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: c.border,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Text(entry.label, style: t.bodySmall),
                        ),
                        Text(Dates.dayMonth(entry.at), style: t.labelSmall),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({required this.task});

  final Task task;

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
                  onPressed: () => unawaited(toggleTask(ref, task)),
                  icon: Icon(
                    task.done
                        ? Symbols.replay_rounded
                        : Symbols.check_rounded,
                    size: 20,
                  ),
                  label: Text(task.done ? 'Reopen' : 'Complete'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Edit',
                icon: const Icon(Symbols.edit_rounded),
                onPressed: () => context.go(Routes.taskEdit(task.id)),
              ),
              IconButton(
                tooltip: 'Duplicate',
                icon: const Icon(Symbols.content_copy_rounded),
                onPressed: () => unawaited(duplicateTask(ref, task)),
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
    final deleted = await confirmAndDelete(context, ref, task);
    if (deleted && context.mounted) context.go(Routes.tasks);
  }
}
