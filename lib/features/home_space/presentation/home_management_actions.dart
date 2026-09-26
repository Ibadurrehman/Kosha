import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/kosha_colors.dart';
import '../../../shared/state/toast_controller.dart';
import '../../tasks/data/task_repository_impl.dart';
import '../../tasks/domain/entities/task.dart';
import '../data/home_management_repository_impl.dart';
import '../domain/entities/appliance.dart';
import '../domain/entities/home_utility.dart';
import '../domain/entities/maintenance_job.dart';

/// Creates a task titled after the job and links it back — section 6.10's
/// "can promote to a task", the same "Make a task" shape Ideas will use in
/// Phase 4.
Future<void> promoteJobToTask(WidgetRef ref, MaintenanceJob job) async {
  final tasks = ref.read(taskRepositoryProvider);
  final homeManagement = ref.read(homeManagementRepositoryProvider);
  final toast = ref.read(toastControllerProvider.notifier);

  final task = await tasks.create(
    NewTask(
      title: job.title,
      dueDate: job.dueDate,
      category: 'Home',
      spaceId: job.spaceId,
      source: TaskSource.maintenanceJob,
    ),
  );
  await homeManagement.editJob(job.id, taskId: task.id);
  toast.show('Added “${job.title}” to Tasks');
}

Future<void> removeUtility(
  BuildContext context,
  WidgetRef ref,
  HomeUtility utility,
) async {
  final repository = ref.read(homeManagementRepositoryProvider);
  final toast = ref.read(toastControllerProvider.notifier);

  await repository.removeUtility(utility.id);
  toast.show(
    'Removed “${utility.name}”',
    onUndo: () => unawaited(
      repository.addUtility(
        NewHomeUtility(
          name: utility.name,
          iconKey: utility.iconKey,
          billId: utility.billId,
        ),
      ),
    ),
  );
}

Future<void> deleteJob(WidgetRef ref, MaintenanceJob job) async {
  final repository = ref.read(homeManagementRepositoryProvider);
  final toast = ref.read(toastControllerProvider.notifier);

  await repository.softDeleteJob(job.id);
  toast.show(
    'Deleted “${job.title}”',
    onUndo: () => unawaited(repository.restoreJob(job.id)),
  );
}

/// Confirms first, then deletes with an undo.
Future<void> confirmAndDeleteJob(
  BuildContext context,
  WidgetRef ref,
  MaintenanceJob job,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('Delete “${job.title}”?'),
      content: const Text('You can undo this straight away.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Keep it'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: TextButton.styleFrom(foregroundColor: dialogContext.kosha.error),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;
  await deleteJob(ref, job);
}

Future<void> deleteAppliance(WidgetRef ref, Appliance appliance) async {
  final repository = ref.read(homeManagementRepositoryProvider);
  final toast = ref.read(toastControllerProvider.notifier);

  await repository.softDeleteAppliance(appliance.id);
  toast.show(
    'Deleted “${appliance.name}”',
    onUndo: () => unawaited(repository.restoreAppliance(appliance.id)),
  );
}

Future<void> confirmAndDeleteAppliance(
  BuildContext context,
  WidgetRef ref,
  Appliance appliance,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('Delete “${appliance.name}”?'),
      content: const Text('You can undo this straight away.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Keep it'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: TextButton.styleFrom(foregroundColor: dialogContext.kosha.error),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;
  await deleteAppliance(ref, appliance);
}
