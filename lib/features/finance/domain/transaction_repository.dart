import 'entities/transaction.dart';

/// Total minor units for one category within a range — Finance's "By
/// category" bars.
class CategoryTotal {
  const CategoryTotal({required this.category, required this.amountMinor});

  final String category;
  final int amountMinor;

  @override
  bool operator ==(Object other) =>
      other is CategoryTotal &&
      other.category == category &&
      other.amountMinor == amountMinor;

  @override
  int get hashCode => Object.hash(category, amountMinor);
}

/// Reads and writes transactions. Search and reminder syncing don't apply
/// here (transactions have no due date and aren't searchable until a later
/// phase — section 13, G21), so this is simpler than `TaskRepository`.
abstract interface class TransactionRepository {
  /// The [limit] most recent transactions, newest first. Finance dashboard's
  /// "Recent transactions".
  Stream<List<Transaction>> watchRecent({required int limit});

  /// Transactions dated in `[from, to)` — end exclusive.
  Stream<List<Transaction>> watchBetween(DateTime from, DateTime to);

  /// Emits null once the transaction is deleted — the detail screen.
  Stream<Transaction?> watchById(String id);

  Future<Transaction?> findById(String id);

  Future<Transaction> create(NewTransaction draft);

  Future<Transaction> save(Transaction transaction);

  /// Marks the transaction deleted but keeps the row so [restore] can bring
  /// it back.
  Future<void> softDelete(String id);

  Future<void> restore(String id);

  /// Removes the row for good. Used to undo a creation.
  Future<void> purge(String id);

  /// Sum of [type] transactions dated in `[from, to)`, in minor units.
  Future<int> sumByType(TransactionType type, {required DateTime from, required DateTime to});

  /// Expense totals per category dated in `[from, to)`, highest first.
  Future<List<CategoryTotal>> categoryTotals({required DateTime from, required DateTime to});

  /// The payment method on the most recent transaction, or null if there
  /// isn't one yet — the New expense sheet's "defaults to last used" method
  /// chip (section 6.6).
  Future<TransactionMethod?> lastMethod();
}
