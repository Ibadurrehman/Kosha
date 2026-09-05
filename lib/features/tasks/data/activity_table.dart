import 'package:drift/drift.dart';

import '../domain/entities/activity_entry.dart';

/// History for tasks today; documents, bills and vehicles reuse it later
/// through [Table.ownerType].
@DataClassName('ActivityRow')
@TableIndex(name: 'activity_owner', columns: {#ownerType, #ownerId})
class ActivityEntries extends Table {
  TextColumn get id => text()();

  TextColumn get ownerType => text()();

  TextColumn get ownerId => text()();

  IntColumn get event => intEnum<ActivityEvent>()();

  /// Short human context, e.g. the date a task was moved to.
  TextColumn get detail => text().nullable()();

  DateTimeColumn get at => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
