import 'package:drift/drift.dart';

/// Lightweight calendar appointments. See `Event` (domain) for why there is
/// no `recurrenceRule`.
@DataClassName('EventRow')
@TableIndex(name: 'events_start', columns: {#startAt})
class Events extends Table {
  TextColumn get id => text()();

  TextColumn get title => text().withLength(min: 1, max: 500)();

  TextColumn get description => text().nullable()();

  DateTimeColumn get startAt => dateTime()();

  DateTimeColumn get endAt => dateTime().nullable()();

  BoolColumn get allDay => boolean().withDefault(const Constant(false))();

  IntColumn get reminderOffsetMinutes => integer().nullable()();

  TextColumn get spaceId => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  /// Set instead of removing the row, so a delete can be undone.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
