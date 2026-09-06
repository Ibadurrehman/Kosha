import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill.freezed.dart';

/// A bill and a subscription are the same row with a different label — a
/// subscription "renews", a bill "is due" (section 6.7). Persisted by index —
/// append only.
enum BillKind {
  bill('Bill'),
  subscription('Subscription');

  const BillKind(this.label);

  final String label;
}

/// Bills-list tabs. Every value except [all] is also a derived status
/// (section 5.2) — [all] is the tab that filters nothing.
enum BillTab {
  all('All'),
  dueSoon('Due Soon'),
  overdue('Overdue'),
  upcoming('Upcoming'),
  paid('Paid');

  const BillTab(this.label);

  final String label;
}

/// Where a bill stands right now. Never stored — see [billStatus].
enum BillStatus { overdue, dueSoon, upcoming, paid }

/// How many days before [Bill.nextDue] a bill reminds by default.
const int defaultBillReminderDays = 3;

@freezed
abstract class Bill with _$Bill {
  const factory Bill({
    required String id,
    required String name,
    required int amountMinor,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(BillKind.bill) BillKind kind,

    /// Local midnight of the next date money is owed.
    ///
    /// Null means nothing is outstanding: a one-off ("on demand") bill that
    /// has been paid has nowhere to advance to, so paying it clears the date
    /// instead of leaving one in the past that would read as overdue for
    /// ever.
    DateTime? nextDue,

    /// An RFC 5545 rule the way tasks store one (`FREQ=MONTHLY;BYMONTHDAY=10`),
    /// or null for a bill that arrives on no schedule. Month-end clamping is
    /// `Recurrence`'s job, which is why 31 Jan → 28 Feb works here for free.
    String? frequencyRule,
    @Default(false) bool autopay,
    @Default(defaultBillReminderDays) int reminderOffsetDays,

    /// The day the most recent payment was recorded. Also the flag behind the
    /// "Paid" status — see [billStatus] for why "has ever been paid" is a
    /// sound reading of "paid for the cycle we are in".
    DateTime? lastPaidOn,
    String? provider,

    /// Consumer number, policy number, last four digits — whatever identifies
    /// the account this bill is drawn against.
    String? accountRef,
    String? notes,
    String? spaceId,
  }) = _Bill;

  const Bill._();

  bool get repeats => (frequencyRule ?? '').isNotEmpty;
}

/// Fields a caller supplies to create a bill; the repository fills in id,
/// timestamps and the payment history.
class NewBill {
  const NewBill({
    required this.name,
    required this.amountMinor,
    this.kind = BillKind.bill,
    this.nextDue,
    this.frequencyRule,
    this.autopay = false,
    this.reminderOffsetDays = defaultBillReminderDays,
    this.provider,
    this.accountRef,
    this.notes,
    this.spaceId,
  });

  final String name;
  final int amountMinor;
  final BillKind kind;
  final DateTime? nextDue;
  final String? frequencyRule;
  final bool autopay;
  final int reminderOffsetDays;
  final String? provider;
  final String? accountRef;
  final String? notes;
  final String? spaceId;
}

/// Section 5.2's bill status, derived and never stored.
///
/// Order matters. Overdue and Due Soon are decided first, so a bill that was
/// paid last cycle but whose *next* due date has already come around reads as
/// due again rather than resting on an old payment. Only once the next due
/// date is comfortably ahead does a previous payment make the bill "Paid" —
/// and at that point `lastPaidOn` being set really does mean the current
/// cycle is settled, because paying is the only thing that advances
/// [Bill.nextDue] past a date that has passed.
BillStatus billStatus(Bill bill, DateTime today) {
  final due = bill.nextDue;
  // A one-off bill with no date left owes nothing.
  if (due == null) return BillStatus.paid;
  if (due.isBefore(today)) return BillStatus.overdue;
  final window = DateTime(
    today.year,
    today.month,
    today.day + bill.reminderOffsetDays,
  );
  if (!due.isAfter(window)) return BillStatus.dueSoon;
  return bill.lastPaidOn == null ? BillStatus.upcoming : BillStatus.paid;
}

/// True when [status] is one the [tab] shows. The All tab shows everything.
bool billMatchesTab(BillStatus status, BillTab tab) => switch (tab) {
      BillTab.all => true,
      BillTab.dueSoon => status == BillStatus.dueSoon,
      BillTab.overdue => status == BillStatus.overdue,
      BillTab.upcoming => status == BillStatus.upcoming,
      BillTab.paid => status == BillStatus.paid,
    };

/// What money is still owed across [bills] — the outstanding total on the
/// Bills screen. Paid bills contribute nothing.
int outstandingMinor(Iterable<Bill> bills, DateTime today) {
  var total = 0;
  for (final bill in bills) {
    if (billStatus(bill, today) != BillStatus.paid) total += bill.amountMinor;
  }
  return total;
}
