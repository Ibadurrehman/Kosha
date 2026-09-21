import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_category.freezed.dart';

/// Which side of the ledger a category belongs to. Persisted by index —
/// append only.
enum CategoryKind { expense, income }

/// A spending or income category the user can rename, reorder and add to.
///
/// Named `TransactionCategory` rather than `Category` because
/// `package:flutter/foundation.dart` already exports a `Category` annotation,
/// and several presentation files import both.
///
/// Transactions store the category *label*, not this row's id (see
/// `transaction_table.dart`). That keeps every existing query — including
/// `categoryTotals`'s `GROUP BY category` — working untouched, and means a
/// category the user later deletes still names the money that was spent under
/// it. The cost is that a rename has to cascade, which
/// `TransactionCategoryRepository.rename` does in one transaction.
@freezed
abstract class TransactionCategory with _$TransactionCategory {
  const factory TransactionCategory({
    required String id,
    required String name,
    required CategoryKind kind,

    /// Position in the manager and in the sheet's chip row, ascending.
    required int sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// A key from [categoryIconKeys], not a raw code point — an `IconData`
    /// constant is tree-shaken by icon, so persisting one would break the
    /// moment the icon stops being referenced in Dart source.
    String? iconKey,
  }) = _TransactionCategory;
}

/// The curated icons a category can carry, keyed by the name stored in the
/// database. `presentation/category_icons.dart` maps these to real symbols.
const List<String> categoryIconKeys = [
  'shopping_basket',
  'restaurant',
  'train',
  'receipt',
  'shopping_bag',
  'health',
  'movie',
  'home',
  'school',
  'pets',
  'savings',
  'more',
];

/// The eight expense categories a fresh install starts with — the prototype's
/// list (section 6.6), seeded on first read rather than in a migration so the
/// repository's injected `Clock` supplies the timestamps (the same reason
/// Profiles and DashboardSections seed lazily — see plan §12.1.3).
const List<(String, String)> defaultExpenseCategories = [
  ('Groceries', 'shopping_basket'),
  ('Food', 'restaurant'),
  ('Transport', 'train'),
  ('Bills', 'receipt'),
  ('Shopping', 'shopping_bag'),
  ('Health', 'health'),
  ('Entertainment', 'movie'),
  ('Other', 'more'),
];

/// Income has one seeded category so the New expense sheet can offer chips on
/// both sides of the toggle without inventing a taxonomy the prototype never
/// showed.
const List<(String, String)> defaultIncomeCategories = [
  ('Salary', 'savings'),
  ('Other', 'more'),
];
