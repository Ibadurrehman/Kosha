import 'package:drift/drift.dart';

import '../../finance/domain/entities/transaction.dart';
import '../domain/entities/bill.dart';

/// Bills and subscriptions (section 6.7). The row class is `BillRow` to match
/// the `TaskRow`/`Task` naming split.
@DataClassName('BillRow')
@TableIndex(name: 'bills_next_due', columns: {#nextDue})
@TableIndex(name: 'bills_space', columns: {#spaceId})
class Bills extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  IntColumn get amountMinor => integer()();

  IntColumn get kind => intEnum<BillKind>()();

  /// Null once a one-off bill has been paid — see [Bill.nextDue].
  DateTimeColumn get nextDue => dateTime().nullable()();

  TextColumn get frequencyRule => text().nullable()();

  BoolColumn get autopay => boolean().withDefault(const Constant(false))();

  IntColumn get reminderOffsetDays =>
      integer().withDefault(const Constant(defaultBillReminderDays))();

  DateTimeColumn get lastPaidOn => dateTime().nullable()();

  TextColumn get provider => text().nullable()();

  TextColumn get accountRef => text().nullable()();

  TextColumn get notes => text().nullable()();

  TextColumn get spaceId => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete, so the toast's undo can bring the bill back and Phase 5's
  /// sync layer can propagate the deletion — the same shape as `Tasks`.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Receipt history. Rows are only ever inserted or removed with their bill —
/// a payment is a fact about a moment, so nothing edits one in place.
@DataClassName('PaymentRow')
@TableIndex(name: 'payments_bill', columns: {#billId, #paidOn})
class Payments extends Table {
  TextColumn get id => text()();

  TextColumn get billId => text().references(Bills, #id)();

  DateTimeColumn get paidOn => dateTime()();

  IntColumn get amountMinor => integer()();

  IntColumn get method => intEnum<TransactionMethod>().nullable()();

  /// The Finance transaction written alongside this payment, if the user
  /// asked for one.
  TextColumn get transactionId => text().nullable()();

  DateTimeColumn get forDueDate => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
