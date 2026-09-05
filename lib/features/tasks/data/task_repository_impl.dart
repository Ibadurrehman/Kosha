import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/app_database.dart';
import '../../../core/utils/clock.dart';
import '../domain/entities/task.dart';
import '../domain/task_repository.dart';

part 'task_repository_impl.g.dart';

/// SQLite-backed tasks. Every write stamps `updatedAt` from the injected
/// [Clock] so tests can assert on timestamps.
class DriftTaskRepository implements TaskRepository {
  DriftTaskRepository(this._db, this._clock);

  static const Uuid _uuid = Uuid();

  final AppDatabase _db;
  final Clock _clock;

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
    await _db.into(_db.tasks).insert(_toRow(task));
    return task;
  }

  @override
  Future<void> save(Task task) async {
    await _db
        .update(_db.tasks)
        .replace(_toRow(task.copyWith(updatedAt: _clock.now())));
  }

  @override
  Future<void> setDone(String id, {required bool done}) async {
    final now = _clock.now();
    await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        done: Value(done),
        completedAt: Value(done ? now : null),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<void> softDelete(String id) async {
    final now = _clock.now();
    await (_db.update(_db.tasks)..where((t) => t.id.equals(id)))
        .write(TasksCompanion(deletedAt: Value(now), updatedAt: Value(now)));
  }

  @override
  Future<void> restore(String id) async {
    await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_clock.now()),
      ),
    );
  }

  @override
  Future<void> purge(String id) async {
    await (_db.delete(_db.tasks)..where((t) => t.id.equals(id))).go();
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
    );
