import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/app_database.dart';
import '../../../core/services/notifications/reminder_scheduler.dart';
import '../../../core/services/notifications/scheduled_reminder.dart';
import '../../../core/services/recurrence/recurrence.dart';
import '../../../core/utils/clock.dart';
import '../../finance/data/transaction_repository_impl.dart';
import '../../finance/domain/entities/transaction.dart';
import '../../finance/domain/transaction_repository.dart';
import '../domain/bill_reminder.dart';
import '../domain/bill_repository.dart';
import '../domain/entities/bill.dart';
import '../domain/entities/payment.dart';

part 'bill_repository_impl.g.dart';

/// The category a bill's own expense is filed under, so paid bills land in
/// Finance's "By category" bars the way a manually typed one would.
const String billExpenseCategory = 'Bills';

/// SQLite-backed bills.
///
/// Every write goes through here so the side effects stay together: the row
/// change, the reminder the operating system holds, and — when a payment is
/// recorded — the Finance transaction that pairs with it. Finance is reached
/// through [TransactionRepository], never through `transaction_table.dart`,
/// the same cross-feature rule Home's aggregators and the notification inbox
/// follow (section 4.2).
class DriftBillRepository implements BillRepository {
  DriftBillRepository(this._db, this._clock, this._scheduler, this._transactions);

  static const Uuid _uuid = Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final ReminderScheduler _scheduler;
  final TransactionRepository _transactions;

  @override
  Stream<List<Bill>> watchAll() {
    final query = _db.select(_db.bills)
      ..where((b) => b.deletedAt.isNull())
      ..orderBy([
        // A bill with nothing outstanding has no date to sort by, so it sits
        // after everything that does.
        (b) => OrderingTerm(expression: b.nextDue, nulls: NullsOrder.last),
        (b) => OrderingTerm.asc(b.name),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<List<Bill>> watchDueBetween(DateTime from, DateTime to) {
    final query = _db.select(_db.bills)
      ..where(
        (b) =>
            b.deletedAt.isNull() &
            b.nextDue.isBiggerOrEqualValue(from) &
            b.nextDue.isSmallerThanValue(to),
      )
      ..orderBy([(b) => OrderingTerm.asc(b.nextDue)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<List<Bill>> watchOverdue({required DateTime today}) {
    final start = DateTime(today.year, today.month, today.day);
    final query = _db.select(_db.bills)
      ..where((b) => b.deletedAt.isNull() & b.nextDue.isSmallerThanValue(start))
      ..orderBy([(b) => OrderingTerm.asc(b.nextDue)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<List<Bill>> watchRecent({required int limit}) {
    final query = _db.select(_db.bills)
      ..where((b) => b.deletedAt.isNull())
      ..orderBy([(b) => OrderingTerm.desc(b.updatedAt)])
      ..limit(limit);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<Bill?> watchById(String id) {
    final query = _db.select(_db.bills)
      ..where((b) => b.id.equals(id) & b.deletedAt.isNull());
    return query.watchSingleOrNull().map((row) => row == null ? null : _toDomain(row));
  }

  @override
  Stream<List<Payment>> watchPayments(String billId) {
    final query = _db.select(_db.payments)
      ..where((p) => p.billId.equals(billId))
      ..orderBy([
        (p) => OrderingTerm.desc(p.paidOn),
        (p) => OrderingTerm.desc(p.createdAt),
      ]);
    return query.watch().map((rows) => rows.map(_paymentToDomain).toList());
  }

  @override
  Future<Bill?> findById(String id) async {
    final row = await (_db.select(_db.bills)
          ..where((b) => b.id.equals(id) & b.deletedAt.isNull()))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<Bill> create(NewBill draft) async {
    final now = _clock.now();
    final bill = Bill(
      id: _uuid.v4(),
      name: draft.name,
      amountMinor: draft.amountMinor,
      kind: draft.kind,
      nextDue: draft.nextDue,
      frequencyRule: draft.frequencyRule,
      autopay: draft.autopay,
      reminderOffsetDays: draft.reminderOffsetDays,
      provider: draft.provider,
      accountRef: draft.accountRef,
      notes: draft.notes,
      spaceId: draft.spaceId,
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.bills).insert(_toRow(bill));
    await _syncReminder(bill);
    return bill;
  }

  @override
  Future<Bill> save(Bill bill) async {
    final existing = await _require(bill.id);
    final updated = bill.copyWith(
      createdAt: existing.createdAt,
      updatedAt: _clock.now(),
    );
    await _db.update(_db.bills).replace(_toRow(updated));
    await _syncReminder(updated);
    return updated;
  }

  @override
  Future<BillPayment> markPaid(
    String id, {
    int? amountMinor,
    DateTime? paidOn,
    TransactionMethod? method,
    bool logExpense = true,
  }) async {
    final bill = await _require(id);
    final now = _clock.now();
    final settledOn = _dateOnly(paidOn ?? now);
    final amount = amountMinor ?? bill.amountMinor;
    final dueSettled = bill.nextDue;

    // A repeating bill moves to its next cycle; a one-off has nowhere to go,
    // so paying it clears the date rather than leaving one in the past that
    // would read as overdue for ever.
    final advanced = dueSettled == null || !bill.repeats
        ? null
        : Recurrence.nextAfter(bill.frequencyRule, dueSettled);

    String? transactionId;
    if (logExpense) {
      final expense = await _transactions.create(
        NewTransaction(
          amountMinor: amount,
          type: TransactionType.expense,
          date: settledOn,
          category: billExpenseCategory,
          method: method,
          label: bill.name,
          billId: bill.id,
          spaceId: bill.spaceId,
        ),
      );
      transactionId = expense.id;
    }

    final payment = Payment(
      id: _uuid.v4(),
      billId: bill.id,
      paidOn: settledOn,
      amountMinor: amount,
      method: method,
      transactionId: transactionId,
      forDueDate: dueSettled,
      createdAt: now,
    );
    await _db.into(_db.payments).insert(_paymentToRow(payment));

    final updated = bill.copyWith(
      nextDue: advanced,
      lastPaidOn: settledOn,
      updatedAt: now,
    );
    await _db.update(_db.bills).replace(_toRow(updated));
    await _syncReminder(updated);

    return BillPayment(
      bill: updated,
      payment: payment,
      transactionId: transactionId,
      previousNextDue: dueSettled,
      previousLastPaidOn: bill.lastPaidOn,
    );
  }

  @override
  Future<void> undoPayment(BillPayment payment) async {
    await (_db.delete(_db.payments)..where((p) => p.id.equals(payment.payment.id)))
        .go();
    final transactionId = payment.transactionId;
    if (transactionId != null) await _transactions.purge(transactionId);

    final bill = await findById(payment.bill.id);
    if (bill == null) return;
    final restored = bill.copyWith(
      nextDue: payment.previousNextDue,
      lastPaidOn: payment.previousLastPaidOn,
      updatedAt: _clock.now(),
    );
    await _db.update(_db.bills).replace(_toRow(restored));
    await _syncReminder(restored);
  }

  @override
  Future<void> softDelete(String id) async {
    final now = _clock.now();
    await (_db.update(_db.bills)..where((b) => b.id.equals(id)))
        .write(BillsCompanion(deletedAt: Value(now), updatedAt: Value(now)));
    await _scheduler.cancel(ReminderKind.bill, id);
  }

  @override
  Future<void> restore(String id) async {
    await (_db.update(_db.bills)..where((b) => b.id.equals(id))).write(
      BillsCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_clock.now()),
      ),
    );
    final restored = await findById(id);
    if (restored != null) await _syncReminder(restored);
  }

  @override
  Future<void> purge(String id) async {
    // Payments reference the bill, so they go first or the foreign key
    // `beforeOpen` turns on would refuse the delete.
    await (_db.delete(_db.payments)..where((p) => p.billId.equals(id))).go();
    await (_db.delete(_db.bills)..where((b) => b.id.equals(id))).go();
    await _scheduler.cancel(ReminderKind.bill, id);
  }

  @override
  Future<void> resyncReminders() async {
    for (final bill in await remindable()) {
      await _syncReminder(bill);
    }
  }

  @override
  Future<List<Bill>> remindable() async {
    final rows = await (_db.select(_db.bills)
          ..where((b) => b.deletedAt.isNull() & b.nextDue.isNotNull()))
        .get();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<void> cancelReminders() async {
    for (final bill in await remindable()) {
      await _scheduler.cancel(ReminderKind.bill, bill.id);
    }
  }

  Future<Bill> _require(String id) async {
    final bill = await findById(id);
    if (bill == null) throw StateError('No bill with id $id');
    return bill;
  }

  Future<void> _syncReminder(Bill bill) async {
    final reminder = reminderForBill(bill, now: _clock.now());
    if (reminder == null) {
      await _scheduler.cancel(ReminderKind.bill, bill.id);
    } else {
      await _scheduler.schedule(reminder);
    }
  }

  static DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  Bill _toDomain(BillRow row) => Bill(
        id: row.id,
        name: row.name,
        amountMinor: row.amountMinor,
        kind: row.kind,
        nextDue: row.nextDue,
        frequencyRule: row.frequencyRule,
        autopay: row.autopay,
        reminderOffsetDays: row.reminderOffsetDays,
        lastPaidOn: row.lastPaidOn,
        provider: row.provider,
        accountRef: row.accountRef,
        notes: row.notes,
        spaceId: row.spaceId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  BillRow _toRow(Bill bill) => BillRow(
        id: bill.id,
        name: bill.name,
        amountMinor: bill.amountMinor,
        kind: bill.kind,
        nextDue: bill.nextDue,
        frequencyRule: bill.frequencyRule,
        autopay: bill.autopay,
        reminderOffsetDays: bill.reminderOffsetDays,
        lastPaidOn: bill.lastPaidOn,
        provider: bill.provider,
        accountRef: bill.accountRef,
        notes: bill.notes,
        spaceId: bill.spaceId,
        createdAt: bill.createdAt,
        updatedAt: bill.updatedAt,
      );

  Payment _paymentToDomain(PaymentRow row) => Payment(
        id: row.id,
        billId: row.billId,
        paidOn: row.paidOn,
        amountMinor: row.amountMinor,
        method: row.method,
        transactionId: row.transactionId,
        forDueDate: row.forDueDate,
        createdAt: row.createdAt,
      );

  PaymentRow _paymentToRow(Payment payment) => PaymentRow(
        id: payment.id,
        billId: payment.billId,
        paidOn: payment.paidOn,
        amountMinor: payment.amountMinor,
        method: payment.method,
        transactionId: payment.transactionId,
        forDueDate: payment.forDueDate,
        createdAt: payment.createdAt,
      );
}

@Riverpod(keepAlive: true)
BillRepository billRepository(Ref ref) => DriftBillRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(clockProvider),
      ref.watch(reminderSchedulerProvider),
      ref.watch(transactionRepositoryProvider),
    );
