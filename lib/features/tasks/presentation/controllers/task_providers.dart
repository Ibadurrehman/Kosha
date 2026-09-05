import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/clock.dart';
import '../../data/task_repository_impl.dart';
import '../../domain/entities/task.dart';

part 'task_providers.g.dart';

/// Open tasks in one Tasks-screen tab.
@riverpod
Stream<List<Task>> tasksInBucket(Ref ref, TaskBucket bucket) {
  final today = ref.watch(clockProvider).today();
  return ref.watch(taskRepositoryProvider).watchBucket(bucket, today: today);
}

/// Everything due today, completed included — Home shows those struck through.
@riverpod
Stream<List<Task>> todayTasks(Ref ref) {
  final today = ref.watch(clockProvider).today();
  return ref.watch(taskRepositoryProvider).watchDueOn(today);
}

/// The tab the Tasks screen is showing. Kept alive so it survives tab switches
/// in the shell.
@Riverpod(keepAlive: true)
class SelectedTaskBucket extends _$SelectedTaskBucket {
  @override
  TaskBucket build() => TaskBucket.today;

  void select(TaskBucket bucket) => state = bucket;
}
