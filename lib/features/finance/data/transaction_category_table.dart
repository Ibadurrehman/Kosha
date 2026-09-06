import 'package:drift/drift.dart';

import '../domain/entities/transaction_category.dart';

/// User-editable spending and income categories (section 5.1's `Category`).
///
/// Colour is deliberately not stored: nothing in the app colours a category
/// today — "By category" bars all use the accent — so a colour column would
/// be data no surface reads. It is a column to add when a surface wants it.
@DataClassName('CategoryRow')
@TableIndex(name: 'categories_kind_sort', columns: {#kind, #sortOrder})
class TransactionCategories extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  IntColumn get kind => intEnum<CategoryKind>()();

  IntColumn get sortOrder => integer()();

  /// One of `categoryIconKeys`, or null for the default folder icon.
  TextColumn get iconKey => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  /// Deleting a category hides it from the pickers but leaves every
  /// transaction's stored label alone, so past months keep reading the way
  /// they were entered.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
