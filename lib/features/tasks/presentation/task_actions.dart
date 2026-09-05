import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/clock.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/state/toast_controller.dart';
import '../data/task_repository_impl.dart';
import '../domain/entities/task.dart';
import 'widgets/delete_task_dialog.dart';
import 'widgets/reschedule_sheet.dart';
import 'widgets/task_actions_sheet.dart';

/// Completes or reopens a task and offers an undo, as the prototype does.
///
/// Completing a repeating task also creates its next occurrence, which the undo
/// has to remove again.
Future<void> toggleTask(WidgetRef ref, Task task) async {
  final repository = ref.read(taskRepositoryProvider);
  final toast = ref.read(toastControllerProvider.notifier);
  final today = ref.read(clockProvider).today();
  final wasDone = task.done;

  final result = await repository.setDone(task.id, done: !wasDone);
  final next = result.nextOccurrence;

  final String message;
  if (wasDone) {
    message = 'Moved back to ${result.task.bucketOn(today).label}';
  } else if (next?.dueDate != null) {
    message = 'Completed · next on ${Dates.dayMonth(next!.dueDate!)}';
  } else {
    message = 'Completed “${task.title}”';
  }

  toast.show(
    message,
    onUndo: () => unawaited(() async {
      await repository.setDone(task.id, done: wasDone);
      if (next != null) await repository.purge(next.id);
    }()),
  );
}

Future<void> duplicateTask(WidgetRef ref, Task task) async {
  final repository = ref.read(taskRepositoryProvider);
  final toast = ref.read(toastControllerProvider.notifier);

  final copy = await repository.duplicate(task.id);
  toast.show(
    'Duplicated “${task.title}”',
    onUndo: () => unawaited(repository.purge(copy.id)),
  );
}

Future<void> deleteTask(WidgetRef ref, Task task) async {
  final repository = ref.read(taskRepositoryProvider);
  final toast = ref.read(toastControllerProvider.notifier);

  await repository.softDelete(task.id);
  toast.show(
    'Deleted “${task.title}”',
    onUndo: () => unawaited(repository.restore(task.id)),
  );
}

Future<void> applyReschedule(
  WidgetRef ref,
  Task task, {
  required DateTime? dueDate,
  int? dueMinutes,
}) async {
  final repository = ref.read(taskRepositoryProvider);
  final toast = ref.read(toastControllerProvider.notifier);
  final previousDate = task.dueDate;
  final previousMinutes = task.dueMinutes;

  await repository.reschedule(
    task.id,
    dueDate: dueDate,
    dueMinutes: dueMinutes,
  );
  toast.show(
    dueDate == null
        ? 'Date cleared'
        : 'Moved to ${Dates.dayMonth(dueDate)}',
    onUndo: () => unawaited(
      repository.reschedule(
        task.id,
        dueDate: previousDate,
        dueMinutes: previousMinutes,
      ),
    ),
  );
}

/// Opens the "•••" sheet and carries out whichever action was picked.
///
/// The detail screen passes [showOpenDetails] as false, so the sheet never
/// offers to open the screen the user is already looking at.
///
/// The caller must stay mounted; [context] is checked after every await.
Future<void> openTaskActions(
  BuildContext context,
  WidgetRef ref,
  Task task, {
  bool showOpenDetails = true,
}) async {
  final action = await showTaskActionsSheet(
    context,
    task: task,
    showOpenDetails: showOpenDetails,
  );
  if (action == null || !context.mounted) return;

  switch (action) {
    case TaskAction.complete:
      await toggleTask(ref, task);
    case TaskAction.reschedule:
      await startReschedule(context, ref, task);
    case TaskAction.openDetails:
      context.go(Routes.taskDetail(task.id));
    case TaskAction.duplicate:
      await duplicateTask(ref, task);
    case TaskAction.delete:
      await confirmAndDelete(context, ref, task);
  }
}

/// Offers the four reschedule presets, falling back to a date picker.
Future<void> startReschedule(
  BuildContext context,
  WidgetRef ref,
  Task task,
) async {
  final choice = await showRescheduleSheet(context, task: task);
  if (choice == null || !context.mounted) return;

  final today = ref.read(clockProvider).today();
  DateTime? date;
  var minutes = task.dueMinutes;

  switch (choice) {
    case RescheduleChoice.laterToday:
      date = today;
      minutes = 20 * 60;
    case RescheduleChoice.tomorrow:
      date = DateTime(today.year, today.month, today.day + 1);
    case RescheduleChoice.nextWeek:
      date = DateTime(today.year, today.month, today.day + 7);
    case RescheduleChoice.pickDate:
      final picked = await showDatePicker(
        context: context,
        initialDate: task.dueDate ?? today,
        firstDate: DateTime(today.year - 1),
        lastDate: DateTime(today.year + 5),
      );
      if (picked == null) return;
      date = picked;
  }

  await applyReschedule(ref, task, dueDate: date, dueMinutes: minutes);
}

/// Confirms first, then deletes with an undo. Returns true when the task went.
Future<bool> confirmAndDelete(
  BuildContext context,
  WidgetRef ref,
  Task task,
) async {
  final confirmed = await showDeleteTaskDialog(context, task: task);
  if (!confirmed || !context.mounted) return false;
  await deleteTask(ref, task);
  return true;
}
