import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/models/priority.dart';
import '../../../../core/utils/dates.dart';

// Re-exported so the many callers that reach for `dateOnly` alongside `Task`
// keep working; the single definition lives in core/utils/dates.dart.
export '../../../../core/utils/dates.dart' show dateOnly;

part 'task.freezed.dart';

/// Where a task came from. Persisted by index — append only.
enum TaskSource { manual, idea, document, bill }

/// The Tasks-screen tab a task falls into. Derived from the due date and
/// completion; never stored (section 5.2 of the implementation plan).
enum TaskBucket {
  inbox('Inbox'),
  today('Today'),
  upcoming('Upcoming'),
  overdue('Overdue'),
  completed('Completed');

  const TaskBucket(this.label);

  final String label;
}



@freezed
abstract class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? description,

    /// Local midnight of the day the task is due; null means "no date".
    DateTime? dueDate,

    /// Minutes since midnight, or null for "any time".
    int? dueMinutes,
    @Default(Priority.none) Priority priority,
    @Default(false) bool done,
    DateTime? completedAt,

    /// RFC 5545 rule, e.g. `FREQ=DAILY`. Empty or null means it never repeats.
    String? recurrenceRule,

    /// Minutes before [dueAt] to fire a reminder; null means no reminder.
    int? reminderOffsetMinutes,
    String? category,
    String? spaceId,
    String? parentTaskId,
    @Default(TaskSource.manual) TaskSource source,
  }) = _Task;

  const Task._();

  bool get repeats => (recurrenceRule ?? '').isNotEmpty;

  bool get hasReminder => reminderOffsetMinutes != null;

  /// Due date and time combined; null when the task has no date. Tasks with no
  /// time are treated as due at midnight.
  DateTime? get dueAt {
    final date = dueDate;
    if (date == null) return null;
    final minutes = dueMinutes ?? 0;
    return DateTime(
      date.year,
      date.month,
      date.day,
      minutes ~/ 60,
      minutes % 60,
    );
  }

  /// Which tab this task belongs to, given local midnight of [today].
  TaskBucket bucketOn(DateTime today) {
    if (done) return TaskBucket.completed;
    final date = dueDate;
    if (date == null) return TaskBucket.inbox;
    final due = dateOnly(date);
    final start = dateOnly(today);
    if (due.isBefore(start)) return TaskBucket.overdue;
    if (due.isAfter(start)) return TaskBucket.upcoming;
    return TaskBucket.today;
  }
}

/// The fields needed to create a task. Ids and timestamps are assigned by the
/// repository so callers cannot invent them.
class NewTask {
  const NewTask({
    required this.title,
    this.description,
    this.dueDate,
    this.dueMinutes,
    this.priority = Priority.none,
    this.recurrenceRule,
    this.reminderOffsetMinutes,
    this.category,
    this.spaceId,
    this.source = TaskSource.manual,
  });

  final String title;
  final String? description;
  final DateTime? dueDate;
  final int? dueMinutes;
  final Priority priority;
  final String? recurrenceRule;
  final int? reminderOffsetMinutes;
  final String? category;
  final String? spaceId;
  final TaskSource source;
}
