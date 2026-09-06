import 'package:drift/drift.dart';

/// 5 fixed rows, keyed by `HomeSectionKey.name`.
///
/// No `createdAt`/`deletedAt`: this is a fixed-row config table, the same
/// precedent the existing `Settings` key/value table already sets — those
/// don't need the full Task-style audit trail.
@DataClassName('DashboardSectionRow')
class DashboardSections extends Table {
  TextColumn get key => text()();

  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  IntColumn get sortOrder => integer()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
