import 'package:drift/drift.dart';

import '../domain/entities/transaction.dart';

/// Expenses and income (section 6.6). The row class is `TransactionRow` to
/// match the `TaskRow`/`Task` naming split.
@DataClassName('TransactionRow')
@TableIndex(name: 'transactions_date', columns: {#date})
@TableIndex(name: 'transactions_space', columns: {#spaceId})
class Transactions extends Table {
  TextColumn get id => text()();

  IntColumn get amountMinor => integer()();

  IntColumn get type => intEnum<TransactionType>()();

  DateTimeColumn get date => dateTime()();

  TextColumn get category => text().nullable()();

  IntColumn get method => intEnum<TransactionMethod>().nullable()();

  TextColumn get label => text().nullable()();

  TextColumn get note => text().nullable()();

  TextColumn get spaceId => text().nullable()();

  TextColumn get billId => text().nullable()();

  TextColumn get vehicleId => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  /// Set instead of removing the row, so a delete can be undone and the
  /// Phase 5 sync layer can propagate the deletion — same pattern as `Tasks`.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
