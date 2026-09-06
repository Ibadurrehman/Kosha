import '../../finance/domain/entities/transaction.dart';
import 'entities/bill.dart';
import 'entities/payment.dart';

/// What recording a payment produced: the bill as it now stands (its
/// `nextDue` advanced, `lastPaidOn` set), the receipt row, and the Finance
/// expense written alongside it if one was asked for.
///
/// The caller needs all three so an undo can put every one of them back.
class BillPayment {
  const BillPayment({
    required this.bill,
    required this.payment,
    required this.previousNextDue,
    required this.previousLastPaidOn,
    this.transactionId,
  });

  final Bill bill;
  final Payment payment;
  final String? transactionId;

  /// What `nextDue`/`lastPaidOn` were before the payment, so undoing restores
  /// the bill exactly rather than guessing a cycle backwards.
  final DateTime? previousNextDue;
  final DateTime? previousLastPaidOn;
}

/// Reads and writes bills and their payment history. Like `TaskRepository`,
/// the implementation owns the side effects a write must carry — the reminder
/// the operating system holds, and the Finance transaction a payment can
/// spawn — so every entry point behaves the same.
abstract interface class BillRepository {
  /// Every bill, soonest due first, with undated ones last.
  Stream<List<Bill>> watchAll();

  /// Bills due in `[from, to)` — end exclusive. Home's "Upcoming" section and
  /// the Calendar aggregator.
  Stream<List<Bill>> watchDueBetween(DateTime from, DateTime to);

  /// Bills whose next due date has passed, oldest first. Home's "Needs
  /// attention" section.
  Stream<List<Bill>> watchOverdue({required DateTime today});

  /// The [limit] most recently created or updated bills, newest first.
  Stream<List<Bill>> watchRecent({required int limit});

  /// Emits null once the bill is deleted.
  Stream<Bill?> watchById(String id);

  /// Newest payment first.
  Stream<List<Payment>> watchPayments(String billId);

  Future<Bill?> findById(String id);

  Future<Bill> create(NewBill draft);

  /// Writes an edited bill. Ignores [Bill.createdAt] changes.
  Future<Bill> save(Bill bill);

  /// Records a payment, advances the bill to its next cycle and — when
  /// [logExpense] is true — writes a matching Finance expense.
  ///
  /// [amountMinor] defaults to the bill's own amount; [paidOn] to today.
  Future<BillPayment> markPaid(
    String id, {
    int? amountMinor,
    DateTime? paidOn,
    TransactionMethod? method,
    bool logExpense = true,
  });

  /// Reverses [markPaid]: removes the receipt and the expense it wrote, and
  /// puts the bill's cycle back where it was.
  Future<void> undoPayment(BillPayment payment);

  /// Marks the bill deleted but keeps the row so [restore] can bring it back.
  Future<void> softDelete(String id);

  Future<void> restore(String id);

  /// Removes the bill and its payment history for good. Used to undo a
  /// creation, where nothing should be left behind.
  Future<void> purge(String id);

  /// Re-registers the reminder for every bill that still owes money.
  Future<void> resyncReminders();

  /// Every bill with a due date left — the candidates notification-inbox
  /// reconciliation checks for a fire moment in the past.
  Future<List<Bill>> remindable();

  /// Cancels every scheduled bill reminder, for the Settings toggle.
  Future<void> cancelReminders();
}
