import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

/// Persisted by index — append only. A transaction is either money coming in
/// or going out; there is no "transfer" kind in v1.
enum TransactionType { expense, income }

/// How the money moved. Nullable on the row: a transaction can be logged
/// without saying how. The New expense sheet defaults to whichever the user
/// picked last (section 6.6).
enum TransactionMethod { upi, card, cash, autopay }

/// Curated categories from the prototype (section 6.6). Free text is not
/// offered in v1 — a Category manager (Phase 2, later slice) replaces this
/// fixed list.
const List<String> expenseCategories = [
  'Groceries',
  'Food',
  'Transport',
  'Bills',
  'Shopping',
  'Health',
  'Entertainment',
  'Other',
];

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    /// Integer minor units (paise) — see `core/utils/formatters.dart`'s
    /// `Money`. Always positive; [type] carries the sign.
    required int amountMinor,
    required TransactionType type,
    required DateTime date,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? category,
    TransactionMethod? method,
    String? label,
    String? note,
    String? spaceId,
    String? billId,
    String? vehicleId,
  }) = _Transaction;
}

/// Fields a caller supplies to create a transaction; the repository fills in
/// id and timestamps.
class NewTransaction {
  const NewTransaction({
    required this.amountMinor,
    required this.type,
    required this.date,
    this.category,
    this.method,
    this.label,
    this.note,
    this.spaceId,
    this.billId,
    this.vehicleId,
  });

  final int amountMinor;
  final TransactionType type;
  final DateTime date;
  final String? category;
  final TransactionMethod? method;
  final String? label;
  final String? note;
  final String? spaceId;
  final String? billId;
  final String? vehicleId;
}
