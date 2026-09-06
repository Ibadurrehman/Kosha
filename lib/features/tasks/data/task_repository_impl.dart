import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/app_database.dart';
import '../../../core/services/notifications/reminder_scheduler.dart';
import '../../../core/services/notifications/scheduled_reminder.dart';
import '../../../core/services/recurrence/recurrence.dart';
import '../../../core/utils/clock.dart';
import '../../../core/utils/formatters.dart';
import '../domain/entities/activity_entry.dart';
import '../domain/entities/task.dart';
import '../domain/task_reminder.dart';
import '../domain/task_repository.dart';

part 'task_repository_impl.g.dart';

/// SQLite-backed tasks.
///
/// Every write goes through here so the three side effects stay together: the
/// row change, the activity line, and the reminder the operating system holds.
class DriftTaskRepository implements TaskRepository {
  DriftTaskRepository(this._db, this._clock, this._scheduler);

  static const Uuid _uuid = Uuid();

  /// The detail screen shows a short history, not an audit trail.
  static const int _activityLimit = 20;

  final AppDatabase _db;
  final Clock _clock;
  final ReminderScheduler _scheduler;

  @override
  Stream<List<Task>> watchBucket(
    TaskBucket bucket, {
    required DateTime today,
  }) {
    final query = _db.select(_db.tasks)
      ..where((t) => t.deletedAt.isNull() & _bucketPredicate(t, bucket, today))
      ..orderBy(_ordering(bucket));
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<List<Task>> watchDueOn(DateTime day) {
    final start = dateOnly(day);
    final end = DateTime(start.year, start.month, start.day + 1);
    final query = _db.select(_db.tasks)
      ..where(
        (t) =>
            t.deletedAt.isNull() &
            t.dueDate.isBiggerOrEqualValue(start) &
            t.dueDate.isSmallerThanValue(end),
      )
      ..orderBy([
        (t) => OrderingTerm(expression: t.dueMinutes, nulls: NullsOrder.last),
        (t) => OrderingTerm.asc(t.createdAt),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<List<Task>> watchDueBetween(DateTime from, DateTime to) {
    final query = _db.select(_db.tasks)
      ..where(
        (t) =>
            t.deletedAt.isNull() &
            t.done.equals(false) &
            t.dueDate.isBiggerOrEqualValue(from) &
            t.dueDate.isSmallerThanValue(to),
      )
      ..orderBy([
        (t) => OrderingTerm.asc(t.dueDate),
        (t) => OrderingTerm(expression: t.dueMinutes, nulls: NullsOrder.last),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<List<Task>> watchRecent({required int limit}) {
    final query = _db.select(_db.tasks)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
      ..limit(limit);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<Task?> watchById(String id) {
    final query = _db.select(_db.tasks)
      ..where((t) => t.id.equals(id) & t.deletedAt.isNull());
    return query.watchSingleOrNull().map((row) => row == null ? null : _toDomain(row));
  }

  @override
  Stream<List<ActivityEntry>> watchActivity(String taskId) {
    final query = _db.select(_db.activityEntries)
      ..where((a) => a.ownerType.equals(taskOwnerType) & a.ownerId.equals(taskId))
      // Several entries can share a timestamp — a complete that spawns the next
      // occurrence writes two — so insertion order breaks the tie.
      ..orderBy([
        (a) => OrderingTerm.desc(a.at),
        (a) => OrderingTerm.desc(a.rowId),
      ])
      ..limit(_activityLimit);
    return query.watch().map(
          (rows) => [
            for (final row in rows)
              ActivityEntry(
                id: row.id,
                event: row.event,
                at: row.at,
                detail: row.detail,
              ),
          ],
        );
  }

  @override
  Future<Task?> findById(String id) async {
    final row = await (_db.select(_db.tasks)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<Task> create(NewTask draft) async {
    final now = _clock.now();
    final due = draft.dueDate;
    final task = Task(
      id: _uuid.v4(),
      title: draft.title.trim(),
      createdAt: now,
      updatedAt: now,
      description: draft.description,
      dueDate: due == null ? null : dateOnly(due),
      dueMinutes: draft.dueMinutes,
      priority: draft.priority,
      recurrenceRule: draft.recurrenceRule,
      reminderOffsetMinutes: draft.reminderOffsetMinutes,
      category: draft.category,
      spaceId: draft.spaceId,
      source: draft.source,
    );
    await _insert(task);
    await _log(task.id, ActivityEvent.created);
    await _syncReminder(task);
    return task;
  }

  @override
  Future<Task> save(Task task) async {
    // The stored creation time wins, so an editor holding a stale copy cannot
    // rewrite when the task came into being.
    final existing = await _require(task.id);
    final updated = task.copyWith(
      createdAt: existing.createdAt,
      updatedAt: _clock.now(),
    );
    await _db.update(_db.tasks).replace(_toRow(updated));
    await _log(updated.id, ActivityEvent.edited);
    await _syncReminder(updated);
    return updated;
  }

  @override
  Future<TaskCompletion> setDone(String id, {required bool done}) async {
    final existing = await _require(id);
    final now = _clock.now();

    await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        done: Value(done),
        completedAt: Value(done ? now : null),
        updatedAt: Value(now),
      ),
    );
    final updated = existing.copyWith(
      done: done,
      completedAt: done ? now : null,
      updatedAt: now,
    );
    await _log(id, done ? ActivityEvent.completed : ActivityEvent.reopened);
    await _syncReminder(updated);

    return TaskCompletion(
      task: updated,
      nextOccurrence: done ? await _spawnNextOccurrence(existing, now) : null,
    );
  }

  @override
  Future<Task> reschedule(
    String id, {
    required DateTime? dueDate,
    int? dueMinutes,
  }) async {
    final existing = await _require(id);
    final now = _clock.now();
    final date = dueDate == null ? null : dateOnly(dueDate);

    await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        dueDate: Value(date),
        dueMinutes: Value(dueMinutes),
        updatedAt: Value(now),
      ),
    );
    final updated = existing.copyWith(
      dueDate: date,
      dueMinutes: dueMinutes,
      updatedAt: now,
    );
    await _log(
      id,
      ActivityEvent.rescheduled,
      detail: date == null ? 'date cleared' : 'to ${Dates.dayMonth(date)}',
    );
    await _syncReminder(updated);
    return updated;
  }

  @override
  Future<Task> duplicate(String id) async {
    final existing = await _require(id);
    final now = _clock.now();
    final copy = existing.copyWith(
      id: _uuid.v4(),
      title: '${existing.title} (copy)',
      done: false,
      completedAt: null,
      parentTaskId: null,
      createdAt: now,
      updatedAt: now,
    );
    await _insert(copy);
    await _log(
      copy.id,
      ActivityEvent.created,
      detail: 'copied from “${existing.title}”',
    );
    await _syncReminder(copy);
    return copy;
  }

  @override
  Future<void> softDelete(String id) async {
    final now = _clock.now();
    await (_db.update(_db.tasks)..where((t) => t.id.equals(id)))
        .write(TasksCompanion(deletedAt: Value(now), updatedAt: Value(now)));
    await _log(id, ActivityEvent.deleted);
    await _scheduler.cancel(ReminderKind.task, id);
  }

  @override
  Future<void> restore(String id) async {
    await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_clock.now()),
      ),
    );
    await _log(id, ActivityEvent.restored);
    final restored = await findById(id);
    if (restored != null) await _syncReminder(restored);
  }

  @override
  Future<void> purge(String id) async {
    await (_db.delete(_db.tasks)..where((t) => t.id.equals(id))).go();
    await (_db.delete(_db.activityEntries)
          ..where((a) => a.ownerType.equals(taskOwnerType) & a.ownerId.equals(id)))
        .go();
    await _scheduler.cancel(ReminderKind.task, id);
  }

  @override
  Future<void> resyncReminders() async {
    for (final task in await remindable()) {
      await _syncReminder(task);
    }
  }

  @override
  Future<List<Task>> remindable() async {
    final rows = await (_db.select(_db.tasks)
          ..where(
            (t) =>
                t.deletedAt.isNull() &
                t.done.equals(false) &
                t.dueDate.isNotNull() &
                t.reminderOffsetMinutes.isNotNull(),
          ))
        .get();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<int> countCompleted({required DateTime from, required DateTime to}) =>
      (_db.select(_db.tasks)
            ..where(
              (t) =>
                  // Deleted tasks stop counting, the same as they do in
                  // countCreated and in every list query — a task you threw
                  // away should not still be padding a "completed this month"
                  // figure.
                  t.deletedAt.isNull() &
                  t.completedAt.isBiggerOrEqualValue(from) &
                  t.completedAt.isSmallerThanValue(to),
            ))
          .get()
          .then((rows) => rows.length);

  @override
  Future<int> countCreated({required DateTime from, required DateTime to}) =>
      (_db.select(_db.tasks)
            ..where(
              (t) =>
                  t.deletedAt.isNull() &
                  t.createdAt.isBiggerOrEqualValue(from) &
                  t.createdAt.isSmallerThanValue(to),
            ))
          .get()
          .then((rows) => rows.length);

  /// Creates the occurrence that replaces a completed repeating task, or null
  /// when the task does not repeat.
  Future<Task?> _spawnNextOccurrence(Task completed, DateTime now) async {
    if (!completed.repeats) return null;
    final from = completed.dueDate ?? DateTime(now.year, now.month, now.day);
    final nextDue = Recurrence.nextAfter(completed.recurrenceRule, from);
    if (nextDue == null) return null;

    final next = completed.copyWith(
      id: _uuid.v4(),
      dueDate: nextDue,
      done: false,
      completedAt: null,
      createdAt: now,
      updatedAt: now,
      // Every occurrence points at the first task in the series.
      parentTaskId: completed.parentTaskId ?? completed.id,
    );
    await _insert(next);
    await _log(next.id, ActivityEvent.created, detail: 'next in the series');
    await _syncReminder(next);
    return next;
  }

  Future<Task> _require(String id) async {
    final task = await findById(id);
    if (task == null) throw StateError('No task with id $id');
    return task;
  }

  Future<void> _insert(Task task) =>
      _db.into(_db.tasks).insert(_toRow(task));

  Future<void> _log(String taskId, ActivityEvent event, {String? detail}) async {
    await _db.into(_db.activityEntries).insert(
          ActivityRow(
            id: _uuid.v4(),
            ownerType: taskOwnerType,
            ownerId: taskId,
            event: event,
            detail: detail,
            at: _clock.now(),
          ),
        );
  }

  Future<void> _syncReminder(Task task) async {
    final reminder = reminderForTask(task, now: _clock.now());
    if (reminder == null) {
      await _scheduler.cancel(ReminderKind.task, task.id);
    } else {
      await _scheduler.schedule(reminder);
    }
  }

  Expression<bool> _bucketPredicate(
    $TasksTable t,
    TaskBucket bucket,
    DateTime today,
  ) {
    final start = dateOnly(today);
    // Built from calendar parts rather than adding 24 hours, so the boundary
    // stays correct on days that gain or lose an hour.
    final tomorrow = DateTime(start.year, start.month, start.day + 1);
    return switch (bucket) {
      TaskBucket.completed => t.done.equals(true),
      TaskBucket.inbox => t.done.equals(false) & t.dueDate.isNull(),
      TaskBucket.overdue =>
        t.done.equals(false) & t.dueDate.isSmallerThanValue(start),
      TaskBucket.today =>
        t.done.equals(false) &
            t.dueDate.isBiggerOrEqualValue(start) &
            t.dueDate.isSmallerThanValue(tomorrow),
      TaskBucket.upcoming =>
        t.done.equals(false) & t.dueDate.isBiggerOrEqualValue(tomorrow),
    };
  }

  List<OrderClauseGenerator<$TasksTable>> _ordering(TaskBucket bucket) {
    return switch (bucket) {
      TaskBucket.completed => [
          (t) => OrderingTerm.desc(t.completedAt),
          (t) => OrderingTerm.desc(t.updatedAt),
        ],
      TaskBucket.inbox => [(t) => OrderingTerm.desc(t.createdAt)],
      TaskBucket.today || TaskBucket.overdue || TaskBucket.upcoming => [
          (t) => OrderingTerm.asc(t.dueDate),
          (t) => OrderingTerm(expression: t.dueMinutes, nulls: NullsOrder.last),
          (t) => OrderingTerm.asc(t.createdAt),
        ],
    };
  }

  Task _toDomain(TaskRow row) => Task(
        id: row.id,
        title: row.title,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        description: row.description,
        dueDate: row.dueDate,
        dueMinutes: row.dueMinutes,
        priority: row.priority,
        done: row.done,
        completedAt: row.completedAt,
        recurrenceRule: row.recurrenceRule,
        reminderOffsetMinutes: row.reminderOffsetMinutes,
        category: row.category,
        spaceId: row.spaceId,
        parentTaskId: row.parentTaskId,
        source: row.source,
      );

  TaskRow _toRow(Task task) => TaskRow(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        dueMinutes: task.dueMinutes,
        priority: task.priority,
        done: task.done,
        completedAt: task.completedAt,
        recurrenceRule: task.recurrenceRule,
        reminderOffsetMinutes: task.reminderOffsetMinutes,
        category: task.category,
        spaceId: task.spaceId,
        parentTaskId: task.parentTaskId,
        source: task.source,
        createdAt: task.createdAt,
        updatedAt: task.updatedAt,
      );
}

@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) => DriftTaskRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(clockProvider),
      ref.watch(reminderSchedulerProvider),
    );
