import 'entities/activity_entry.dart';
import 'entities/task.dart';

/// The outcome of completing or reopening a task.
///
/// Completing a repeating task also creates the occurrence that takes its
/// place, and an undo has to remove that occurrence again, so the caller needs
/// both rows back.
class TaskCompletion {
  const TaskCompletion({required this.task, this.nextOccurrence});

  final Task task;
  final Task? nextOccurrence;
}

/// Reads and writes tasks. The implementation owns every side effect that must
/// follow a write — activity history and reminder scheduling today, the search
/// index later — so all entry points behave the same.
abstract interface class TaskRepository {
  /// Open tasks in [bucket] on [today]; [TaskBucket.completed] returns done
  /// tasks, newest first.
  Stream<List<Task>> watchBucket(TaskBucket bucket, {required DateTime today});

  /// Every task due on [day], completed ones included. Home's "Today" section
  /// shows completed tasks struck through, so it cannot use [watchBucket].
  Stream<List<Task>> watchDueOn(DateTime day);

  /// Open tasks due in `[from, to)` — end exclusive. Home's "Upcoming"
  /// section.
  Stream<List<Task>> watchDueBetween(DateTime from, DateTime to);

  /// The [limit] most recently created or updated tasks, any status, newest
  /// first. Home's "Recent" section.
  Stream<List<Task>> watchRecent({required int limit});

  /// Emits null once the task is deleted.
  Stream<Task?> watchById(String id);

  /// Newest first, for the detail screen's activity section.
  Stream<List<ActivityEntry>> watchActivity(String taskId);

  Future<Task?> findById(String id);

  Future<Task> create(NewTask draft);

  /// Writes an edited task. Ignores [Task.createdAt] changes.
  Future<Task> save(Task task);

  Future<TaskCompletion> setDone(String id, {required bool done});

  /// Moves a task's due date and time, logging it as a reschedule.
  Future<Task> reschedule(
    String id, {
    required DateTime? dueDate,
    int? dueMinutes,
  });

  /// Copies a task as "<title> (copy)", open and detached from any series.
  Future<Task> duplicate(String id);

  /// Marks the task deleted but keeps the row so [restore] can bring it back.
  Future<void> softDelete(String id);

  Future<void> restore(String id);

  /// Removes the row and its history for good. Used to undo a creation, where
  /// nothing should be left behind.
  Future<void> purge(String id);

  /// Re-registers the reminder for every open, dated task.
  ///
  /// Scheduled notifications do not survive a reinstall, and platforms drop
  /// them on some upgrades, so the app re-states what it expects on launch.
  Future<void> resyncReminders();

  /// Every open, dated task with a reminder lead time set — the candidates
  /// notification-inbox reconciliation checks for a fire moment in the past.
  Future<List<Task>> remindable();
}
