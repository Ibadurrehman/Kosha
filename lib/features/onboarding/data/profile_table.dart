import 'package:drift/drift.dart';

/// The single local profile row, id always `'local'`.
@DataClassName('ProfileRow')
class Profiles extends Table {
  TextColumn get id => text()();

  TextColumn get name => text().withDefault(const Constant('You'))();

  TextColumn get email => text().nullable()();

  TextColumn get avatarInitials => text().withDefault(const Constant('Y'))();

  DateTimeColumn get joinedAt => dateTime()();

  TextColumn get currency => text().withDefault(const Constant('INR'))();

  TextColumn get dateFormat =>
      text().withDefault(const Constant('d MMM yyyy'))();

  IntColumn get weekStart => integer().withDefault(const Constant(1))();

  TextColumn get locale => text().withDefault(const Constant('en'))();

  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
