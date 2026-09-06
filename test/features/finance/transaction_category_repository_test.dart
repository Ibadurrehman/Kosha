import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/finance/data/transaction_category_repository_impl.dart';
import 'package:kosha/features/finance/data/transaction_repository_impl.dart';
import 'package:kosha/features/finance/domain/entities/transaction.dart';
import 'package:kosha/features/finance/domain/entities/transaction_category.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DriftTransactionCategoryRepository repository;
  late DriftTransactionRepository transactions;

  setUp(() {
    db = testDatabase();
    repository = testCategoryRepository(db);
    transactions = testTransactionRepository(db);
  });

  tearDown(() => db.close());

  Future<Transaction> spend(String category, {int amountMinor = 45000}) =>
      transactions.create(
        NewTransaction(
          amountMinor: amountMinor,
          type: TransactionType.expense,
          date: testToday,
          category: category,
        ),
      );

  group('seeding', () {
    test('a first read seeds the prototype list, in order', () async {
      final categories = await repository.listByKind(CategoryKind.expense);
      expect(
        categories.map((c) => c.name),
        defaultExpenseCategories.map((d) => d.$1),
      );
      expect(categories.first.iconKey, 'shopping_basket');
      expect(categories.first.createdAt, testNow);
    });

    test('income gets its own, smaller set', () async {
      final categories = await repository.listByKind(CategoryKind.income);
      expect(categories.map((c) => c.name), ['Salary', 'Other']);
    });

    test('reading twice does not seed twice', () async {
      await repository.listByKind(CategoryKind.expense);
      final second = await repository.listByKind(CategoryKind.expense);
      expect(second, hasLength(defaultExpenseCategories.length));
    });

    test('deleting every category does not bring the defaults back', () async {
      final categories = await repository.listByKind(CategoryKind.expense);
      for (final category in categories) {
        await repository.softDelete(category.id);
      }
      expect(await repository.listByKind(CategoryKind.expense), isEmpty);
    });
  });

  group('create', () {
    test('appends to the end of its kind', () async {
      final created = await repository.create(
        name: 'Travel',
        kind: CategoryKind.expense,
        iconKey: 'train',
      );
      expect(created.sortOrder, defaultExpenseCategories.length);
      final list = await repository.listByKind(CategoryKind.expense);
      expect(list.last.name, 'Travel');
    });

    test('does not appear on the other side of the ledger', () async {
      await repository.create(name: 'Travel', kind: CategoryKind.expense);
      final income = await repository.listByKind(CategoryKind.income);
      expect(income.map((c) => c.name), isNot(contains('Travel')));
    });
  });

  group('rename', () {
    test('relabels every transaction that carried the old name', () async {
      final categories = await repository.listByKind(CategoryKind.expense);
      final groceries = categories.firstWhere((c) => c.name == 'Groceries');
      final a = await spend('Groceries');
      final b = await spend('Groceries');
      final other = await spend('Food');

      final relabelled = await repository.rename(groceries.id, 'Supermarket');

      expect(relabelled, 2);
      expect((await transactions.findById(a.id))!.category, 'Supermarket');
      expect((await transactions.findById(b.id))!.category, 'Supermarket');
      expect((await transactions.findById(other.id))!.category, 'Food');
      expect(
        (await repository.findById(groceries.id))!.name,
        'Supermarket',
      );
    });

    test('reports zero when nothing was filed under it', () async {
      final categories = await repository.listByKind(CategoryKind.expense);
      expect(await repository.rename(categories.first.id, 'Renamed'), 0);
    });

    test('keeps the category totals adding up after a rename', () async {
      final categories = await repository.listByKind(CategoryKind.expense);
      final groceries = categories.firstWhere((c) => c.name == 'Groceries');
      await spend('Groceries', amountMinor: 100000);
      await repository.rename(groceries.id, 'Supermarket');

      final totals = await transactions.categoryTotals(
        from: DateTime(2026, 9),
        to: DateTime(2026, 10),
      );
      expect(totals.single.category, 'Supermarket');
      expect(totals.single.amountMinor, 100000);
    });
  });

  group('delete', () {
    test('hides the category but leaves the transactions labelled', () async {
      final categories = await repository.listByKind(CategoryKind.expense);
      final groceries = categories.firstWhere((c) => c.name == 'Groceries');
      final spent = await spend('Groceries');

      await repository.softDelete(groceries.id);

      final remaining = await repository.listByKind(CategoryKind.expense);
      expect(remaining.map((c) => c.name), isNot(contains('Groceries')));
      expect((await transactions.findById(spent.id))!.category, 'Groceries');
    });

    test('restore brings it back in its old position', () async {
      final categories = await repository.listByKind(CategoryKind.expense);
      final food = categories.firstWhere((c) => c.name == 'Food');
      await repository.softDelete(food.id);
      await repository.restore(food.id);

      final restored = await repository.listByKind(CategoryKind.expense);
      expect(restored.map((c) => c.name).toList().indexOf('Food'), 1);
    });

    test('transactionCount is what the confirmation quotes', () async {
      final categories = await repository.listByKind(CategoryKind.expense);
      final groceries = categories.firstWhere((c) => c.name == 'Groceries');
      await spend('Groceries');
      await spend('Groceries');
      expect(await repository.transactionCount(groceries.id), 2);
    });
  });

  group('reorder', () {
    test('persists the new order', () async {
      final categories = await repository.listByKind(CategoryKind.expense);
      final ids = [for (final c in categories) c.id];
      final moved = [ids.last, ...ids.take(ids.length - 1)];

      await repository.reorder(CategoryKind.expense, moved);

      final reordered = await repository.listByKind(CategoryKind.expense);
      expect(reordered.map((c) => c.id), moved);
      expect(reordered.first.name, 'Other');
    });
  });
}
