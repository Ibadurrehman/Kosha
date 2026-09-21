import 'package:drift/drift.dart';

import '../domain/entities/space.dart';

/// Stores a [SpaceHolds] set as a comma-joined list of enum *names*.
///
/// Sets are written in enum-declaration order so the same selection always
/// produces the same string — otherwise a re-save with an identical selection
/// would look like a change to drift's stream comparison and to any future
/// sync diff. Unknown names are dropped rather than throwing, so a database
/// written by a newer build (one that added a hold kind) still opens.
class SpaceHoldsConverter extends TypeConverter<Set<SpaceHolds>, String> {
  const SpaceHoldsConverter();

  @override
  Set<SpaceHolds> fromSql(String fromDb) {
    if (fromDb.isEmpty) return const {};
    final names = fromDb.split(',').toSet();
    return {
      for (final hold in SpaceHolds.values)
        if (names.contains(hold.name)) hold,
    };
  }

  @override
  String toSql(Set<SpaceHolds> value) =>
      [for (final hold in SpaceHolds.values) if (value.contains(hold)) hold.name]
          .join(',');
}

/// Spaces (section 6.5). The row class is `SpaceRow` to match the
/// `TaskRow`/`Task` naming split.
///
/// **This table has no `deletedAt`,** unlike every other table in the
/// database. Section 6.5's acceptance criterion is that deleting a user space
/// *archives* it and unlinks its items, which the items survive — so archiving
/// is the only removal a space has, and a second timestamp meaning "gone for
/// real" would be a column no surface writes. The same reasoning the
/// categories table gives for not storing a colour: it is a column to add when
/// something wants it, and Phase 5 syncs `archivedAt` as the state field it is.
@DataClassName('SpaceRow')
@TableIndex(name: 'spaces_sort', columns: {#sortOrder})
@TableIndex(name: 'spaces_system_key', columns: {#systemKey}, unique: true)
class Spaces extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  IntColumn get kind => intEnum<SpaceKind>()();

  /// Set for system rows, null for user-made ones. Stored by name because it
  /// is an identity the code matches on — see [SystemSpace].
  ///
  /// The unique index covers this column, which is what stops a second seeding
  /// run from ever producing two Finance spaces. SQLite treats NULLs as
  /// distinct in a unique index, so any number of custom spaces is still fine.
  TextColumn get systemKey => textEnum<SystemSpace>().nullable()();

  TextColumn get holds => text().map(const SpaceHoldsConverter())();

  IntColumn get sortOrder => integer()();

  /// One of `spaceIconKeys`, or null for the default folder icon.
  TextColumn get iconKey => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
