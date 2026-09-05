import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/clock.dart';
import '../../../shared/state/toast_controller.dart';
import '../data/task_repository_impl.dart';
import '../domain/entities/task.dart';

/// Completes or un-completes a task and offers an undo, as the prototype does.
///
/// Call this from a widget that stays mounted; it reads providers before and
/// after the write.
Future<void> toggleTask(WidgetRef ref, Task task) async {
  final repository = ref.read(taskRepositoryProvider);
  final toast = ref.read(toastControllerProvider.notifier);
  final today = ref.read(clockProvider).today();
  final wasDone = task.done;

  await repository.setDone(task.id, done: !wasDone);

  final message = wasDone
      ? 'Moved back to ${task.copyWith(done: false).bucketOn(today).label}'
      : 'Completed “${task.title}”';
  toast.show(
    message,
    onUndo: () => unawaited(repository.setDone(task.id, done: wasDone)),
  );
}
