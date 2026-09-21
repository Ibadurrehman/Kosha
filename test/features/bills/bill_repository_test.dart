import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/services/notifications/scheduled_reminder.dart';
import 'package:kosha/core/services/recurrence/recurrence.dart';
import 'package:kosha/features/bills/data/bill_repository_impl.dart';
import 'package:kosha/features/bills/domain/entities/bill.dart';
import 'package:kosha/features/finance/data/transaction_repository_impl.dart';
import 'package:kosha/features/finance/domain/entities/transaction.dart';

import '../../helpers/fake_reminder_scheduler.dart';
import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late RecordingReminderScheduler scheduler;
  late DriftBillRepository repository;
  late DriftTransactionRepository transactions;

  setUp(() {
    db = testDatabase();
    scheduler = RecordingReminderScheduler();
    repository = testBillRepository(db, scheduler: scheduler);
    transactions = testTransactionRepository(db);
  });

  tearDown(() => db.close());

  /// [dated] is a separate flag rather than "pass null for nextDue", because
  /// a `??` default would silently turn an explicit null back into a date and
  /// the dateless cases would never actually be exercised.
  Future<Bill> add({
    String name = 'Electricity',
    int amountMinor = 185000,
    DateTime? nextDue,
    bool dated = true,
    String? frequencyRule = 'FREQ=MONTHLY;BYMONTHDAY=10',
    BillKind kind = BillKind.bill,
    int reminderOffsetDays = 3,
    bool autopay = false,
  }) =>
      repository.create(
        NewBill(
          name: name,
          amountMinor: amountMinor,
          nextDue: dated ? (nextDue ?? DateTime(2026, 9, 10)) : null,
          frequencyRule: frequencyRule,
          kind: kind,
          reminderOffsetDays: reminderOffsetDays,
          autopay: autopay,
        ),
      );

  group('create', () {
    test('assigns an id and timestamps from the clock', () async {
      final bill = await add();
      expect(bill.id, isNotEmpty);
      expect(bill.createdAt, testNow);
      expect(bill.updatedAt, testNow);
      expect(await repository.findById(bill.id), bill);
    });

    test('schedules the reminder its lead time before the due date', () async {
      final bill = await add(nextDue: DateTime(2026, 9, 10));
      final reminder = scheduler.latestFor(bill.id);
      expect(reminder, isNotNull);
      expect(reminder!.kind, ReminderKind.bill);
      expect(reminder.fireAt, DateTime(2026, 9, 7, 9));
      expect(reminder.route, '/home/finance/bills/${bill.id}');
    });

    test('a bill with no date schedules nothing', () async {
      final bill = await add(dated: false, frequencyRule: null);
      expect(scheduler.latestFor(bill.id), isNull);
      expect(scheduler.cancelled, contains(bill.id));
    });
  });

  group('markPaid', () {
    test('records a receipt, advances the cycle and writes an expense',
        () async {
      final bill = await add(nextDue: DateTime(2026, 9, 10));
      final result = await repository.markPaid(bill.id);

      expect(result.payment.amountMinor, 185000);
      expect(result.payment.paidOn, testToday);
      expect(result.payment.forDueDate, DateTime(2026, 9, 10));
      expect(result.bill.nextDue, DateTime(2026, 10, 10));
      expect(result.bill.lastPaidOn, testToday);

      final expense = await transactions.findById(result.transactionId!);
      expect(expense, isNotNull);
      expect(expense!.amountMinor, 185000);
      expect(expense.type, TransactionType.expense);
      expect(expense.category, billExpenseCategory);
      expect(expense.label, 'Electricity');
      expect(expense.billId, bill.id);
    });

    test('an amount and method override the defaults', () async {
      final bill = await add();
      final result = await repository.markPaid(
        bill.id,
        amountMinor: 191000,
        paidOn: DateTime(2026, 9, 3),
        method: TransactionMethod.upi,
      );
      expect(result.payment.amountMinor, 191000);
      expect(result.payment.paidOn, DateTime(2026, 9, 3));
      expect(result.payment.method, TransactionMethod.upi);

      final expense = await transactions.findById(result.transactionId!);
      expect(expense!.date, DateTime(2026, 9, 3));
      expect(expense.method, TransactionMethod.upi);
    });

    test('logExpense: false records the receipt only', () async {
      final bill = await add();
      final result = await repository.markPaid(bill.id, logExpense: false);
      expect(result.transactionId, isNull);
      expect(await transactions.watchRecent(limit: 10).first, isEmpty);
    });

    test('month-end arithmetic clamps: 31 Jan advances to 28 Feb', () async {
      final bill = await add(
        nextDue: DateTime(2026, 1, 31),
        frequencyRule: Recurrence.ruleFor(
          RecurrencePreset.monthly,
          start: DateTime(2026, 1, 31),
        ),
      );
      final result = await repository.markPaid(bill.id);
      // 2026 is not a leap year, so February is 28 days long.
      expect(result.bill.nextDue, DateTime(2026, 2, 28));
    });

    test('a one-off has nowhere to advance to, so paying clears the date',
        () async {
      final bill = await add(frequencyRule: null);
      final result = await repository.markPaid(bill.id);
      expect(result.bill.nextDue, isNull);
      expect(result.bill.lastPaidOn, testToday);
      // Nothing left to remind about.
      expect(scheduler.cancelled, contains(bill.id));
    });

    test('paying re-schedules the reminder onto the new cycle', () async {
      final bill = await add(nextDue: DateTime(2026, 9, 10));
      scheduler.clear();
      await repository.markPaid(bill.id);
      expect(scheduler.latestFor(bill.id)!.fireAt, DateTime(2026, 10, 7, 9));
    });

    test('the payment shows up in the history, newest first', () async {
      final bill = await add();
      await repository.markPaid(bill.id, paidOn: DateTime(2026, 7, 10));
      await repository.markPaid(bill.id, paidOn: DateTime(2026, 8, 10));
      final payments = await repository.watchPayments(bill.id).first;
      expect(payments.map((p) => p.paidOn), [
        DateTime(2026, 8, 10),
        DateTime(2026, 7, 10),
      ]);
    });
  });

  group('undoPayment', () {
    test('removes the receipt and the expense, and puts the cycle back',
        () async {
      final bill = await add(nextDue: DateTime(2026, 9, 10));
      final result = await repository.markPaid(bill.id);

      await repository.undoPayment(result);

      final restored = await repository.findById(bill.id);
      expect(restored!.nextDue, DateTime(2026, 9, 10));
      expect(restored.lastPaidOn, isNull);
      expect(await repository.watchPayments(bill.id).first, isEmpty);
      expect(await transactions.findById(result.transactionId!), isNull);
    });

    test('undoing the second payment leaves the first one alone', () async {
      final bill = await add(nextDue: DateTime(2026, 8, 10));
      final first = await repository.markPaid(bill.id, paidOn: DateTime(2026, 8, 9));
      final second = await repository.markPaid(bill.id);

      await repository.undoPayment(second);

      final restored = await repository.findById(bill.id);
      expect(restored!.nextDue, first.bill.nextDue);
      expect(restored.lastPaidOn, DateTime(2026, 8, 9));
      expect(await repository.watchPayments(bill.id).first, hasLength(1));
    });
  });

  group('delete', () {
    test('soft delete hides the bill and cancels its reminder; restore undoes both',
        () async {
      final bill = await add();
      await repository.softDelete(bill.id);
      expect(await repository.findById(bill.id), isNull);
      expect(scheduler.cancelled, contains(bill.id));

      scheduler.clear();
      await repository.restore(bill.id);
      expect(await repository.findById(bill.id), isNotNull);
      expect(scheduler.latestFor(bill.id), isNotNull);
    });

    test('purge removes the payment history with the bill', () async {
      final bill = await add();
      await repository.markPaid(bill.id);
      await repository.purge(bill.id);
      expect(await repository.findById(bill.id), isNull);
      expect(await repository.watchPayments(bill.id).first, isEmpty);
    });
  });

  group('queries', () {
    test('watchAll sorts by due date and puts dateless bills last', () async {
      await add(name: 'Late', nextDue: DateTime(2026, 9, 20));
      await add(name: 'Early', nextDue: DateTime(2026, 9, 5));
      await add(name: 'Settled', dated: false, frequencyRule: null);

      final all = await repository.watchAll().first;
      expect(all.map((b) => b.name), ['Early', 'Late', 'Settled']);
    });

    test('watchOverdue returns only bills whose date has passed', () async {
      await add(name: 'Overdue', nextDue: DateTime(2026, 9, 1));
      await add(name: 'Today', nextDue: testToday);
      await add(name: 'Later', nextDue: DateTime(2026, 9, 20));

      final overdue = await repository.watchOverdue(today: testToday).first;
      expect(overdue.map((b) => b.name), ['Overdue']);
    });

    test('watchDueBetween is end-exclusive', () async {
      await add(name: 'In', nextDue: DateTime(2026, 9, 5));
      await add(name: 'Edge', nextDue: DateTime(2026, 9, 11));

      final due = await repository
          .watchDueBetween(DateTime(2026, 9, 5), DateTime(2026, 9, 11))
          .first;
      expect(due.map((b) => b.name), ['In']);
    });

    test('remindable skips bills with nothing owed', () async {
      final settled = await add(name: 'Settled', frequencyRule: null);
      await repository.markPaid(settled.id);
      await add(name: 'Open');

      final remindable = await repository.remindable();
      expect(remindable.map((b) => b.name), ['Open']);
    });

    test('cancelReminders clears every scheduled bill', () async {
      final bill = await add();
      scheduler.clear();
      await repository.cancelReminders();
      expect(scheduler.cancelled, contains(bill.id));
    });
  });
}
