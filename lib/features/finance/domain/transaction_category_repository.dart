import 'entities/transaction_category.dart';

/// Reads and writes the user's categories.
///
/// The default set is seeded on first read rather than in a migration, so the
/// repository's injected `Clock` supplies the timestamps — the same choice
/// Profiles and DashboardSections made (plan §12.1.3).
abstract interface class TransactionCategoryRepository {
  /// Live list for one side of the ledger, in the user's order.
  Stream<List<TransactionCategory>> watchByKind(CategoryKind kind);

  /// One read of [watchByKind], for callers that only need a snapshot.
  Future<List<TransactionCategory>> listByKind(CategoryKind kind);

  Future<TransactionCategory?> findById(String id);

  /// Appends a category at the end of its kind's order.
  Future<TransactionCategory> create({
    required String name,
    required CategoryKind kind,
    String? iconKey,
  });

  /// Renames a category and rewrites the label on every transaction that
  /// carried the old name, in one database transaction — transactions store
  /// the label, not the id (see [TransactionCategory]).
  ///
  /// Returns the number of transactions that were relabelled.
  Future<int> rename(String id, String name);

  Future<TransactionCategory> setIcon(String id, String? iconKey);

  /// Persists a whole kind's order from a reordered list of ids.
  Future<void> reorder(CategoryKind kind, List<String> orderedIds);

  /// Hides the category from the pickers. Transactions keep the label they
  /// were saved with, so past months read the way they were entered.
  Future<void> softDelete(String id);

  Future<void> restore(String id);

  /// How many live transactions carry this category's name — what the delete
  /// confirmation tells the user before hiding it.
  Future<int> transactionCount(String id);
}
