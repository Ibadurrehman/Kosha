import 'package:drift/drift.dart';

import '../../../core/models/priority.dart';
import '../domain/entities/task.dart';

/// Tasks, reminders and recurring habits.
///
/// The row class is `TaskRow` so it does not collide with the domain [Task].
/// Enum columns store the enum index — append to those enums, never reorder.
@DataClassName('TaskRow')
@TableIndex(name: 'tasks_bucket', columns: {#done, #dueDate})
@TableIndex(name: 'tasks_space', columns: {#spaceId})
class Tasks extends Table {
  TextColumn get id => text()();

  TextColumn get title => text().withLength(min: 1, max: 500)();

  TextColumn get description => text().nullable()();

  DateTimeColumn get dueDate => dateTime().nullable()();

  IntColumn get dueMinutes => integer().nullable()();

  IntColumn get priority =>
      intEnum<Priority>().withDefault(const Constant(0))();

  BoolColumn get done => boolean().withDefault(const Constant(false))();

  DateTimeColumn get completedAt => dateTime().nullable()();

  TextColumn get recurrenceRule => text().nullable()();

  IntColumn get reminderOffsetMinutes => integer().nullable()();

  TextColumn get category => text().nullable()();

  TextColumn get spaceId => text().nullable()();

  TextColumn get parentTaskId => text().nullable()();

  IntColumn get source =>
      intEnum<TaskSource>().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  /// Set instead of removing the row, so a delete can be undone and so the
  /// Phase 5 sync layer can propagate the deletion.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
