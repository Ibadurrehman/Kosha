import 'entities/task.dart';

/// Reads and writes tasks. The implementation owns every side effect that must
/// follow a write (activity log, reminder sync, search index), so all entry
/// points behave the same.
abstract interface class TaskRepository {
  /// Open tasks in [bucket] on [today]; [TaskBucket.completed] returns done
  /// tasks, newest first.
  Stream<List<Task>> watchBucket(TaskBucket bucket, {required DateTime today});

  /// Every task due on [day], completed ones included. Home's "Today" section
  /// shows completed tasks struck through, so it cannot use [watchBucket].
  Stream<List<Task>> watchDueOn(DateTime day);

  Future<Task?> findById(String id);

  Future<Task> create(NewTask draft);

  Future<void> save(Task task);

  Future<void> setDone(String id, {required bool done});

  /// Marks the task deleted but keeps the row so [restore] can bring it back.
  Future<void> softDelete(String id);

  Future<void> restore(String id);

  /// Removes the row for good. Used to undo a creation, where nothing should
  /// be left behind.
  Future<void> purge(String id);
}
