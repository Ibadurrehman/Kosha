import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/utils/clock.dart';
import 'package:kosha/features/finance/data/transaction_repository_impl.dart';
import 'package:kosha/features/finance/domain/entities/transaction.dart';
import 'package:kosha/features/finance/domain/transaction_repository.dart';

import '../../helpers/test_app.dart';

void main() {
  final now = DateTime(2026, 9, 4, 9, 41);

  late AppDatabase db;
  late TransactionRepository repository;

  setUp(() {
    db = testDatabase();
    repository = DriftTransactionRepository(db, FixedClock(now));
  });

  tearDown(() => db.close());

  Future<Transaction> add({
    required int amountMinor,
    TransactionType type = TransactionType.expense,
    DateTime? date,
    String? category,
    TransactionMethod? method,
  }) =>
      repository.create(
        NewTransaction(
          amountMinor: amountMinor,
          type: type,
          date: date ?? DateTime(2026, 9, 4),
          category: category,
          method: method,
        ),
      );

  group('create', () {
    test('assigns an id and timestamps from the clock', () async {
      final transaction = await add(amountMinor: 15000);
      expect(transaction.id, isNotEmpty);
      expect(transaction.createdAt, now);
      expect(transaction.updatedAt, now);
      expect(await repository.findById(transaction.id), transaction);
    });
  });

  group('save', () {
    test('keeps the original createdAt and bumps updatedAt', () async {
      final created = await add(amountMinor: 15000);
      final laterRepository = DriftTransactionRepository(
        db,
        FixedClock(now.add(const Duration(days: 1))),
      );
      final saved = await laterRepository.save(created.copyWith(amountMinor: 20000));
      expect(saved.amountMinor, 20000);
      expect(saved.createdAt, created.createdAt);
      expect(saved.updatedAt, now.add(const Duration(days: 1)));
    });
  });

  group('softDelete / restore / purge', () {
    test('a soft-deleted transaction disappears until restored', () async {
      final transaction = await add(amountMinor: 5000);
      await repository.softDelete(transaction.id);
      expect(await repository.findById(transaction.id), isNull);

      await repository.restore(transaction.id);
      expect(await repository.findById(transaction.id), isNotNull);
    });

    test('purge removes the row for good', () async {
      final transaction = await add(amountMinor: 5000);
      await repository.purge(transaction.id);
      expect(await repository.findById(transaction.id), isNull);
    });
  });

  group('watchBetween', () {
    test('only returns transactions dated inside the range, newest first', () async {
      await add(amountMinor: 100, date: DateTime(2026, 8, 31));
      final inRange1 = await add(amountMinor: 200, date: DateTime(2026, 9, 1));
      final inRange2 = await add(amountMinor: 300, date: DateTime(2026, 9, 30));
      await add(amountMinor: 400, date: DateTime(2026, 10, 1));

      final result = await repository
          .watchBetween(DateTime(2026, 9, 1), DateTime(2026, 10, 1))
          .first;
      expect(result.map((t) => t.id), [inRange2.id, inRange1.id]);
    });

    test('excludes soft-deleted transactions', () async {
      final transaction = await add(amountMinor: 100, date: DateTime(2026, 9, 1));
      await repository.softDelete(transaction.id);

      final result = await repository
          .watchBetween(DateTime(2026, 9, 1), DateTime(2026, 10, 1))
          .first;
      expect(result, isEmpty);
    });
  });

  group('sumByType', () {
    test('sums only the requested type in range', () async {
      await add(amountMinor: 1000, type: TransactionType.expense);
      await add(amountMinor: 2000, type: TransactionType.expense);
      await add(amountMinor: 50000, type: TransactionType.income);

      final expenses = await repository.sumByType(
        TransactionType.expense,
        from: DateTime(2026, 9, 1),
        to: DateTime(2026, 10, 1),
      );
      expect(expenses, 3000);

      final income = await repository.sumByType(
        TransactionType.income,
        from: DateTime(2026, 9, 1),
        to: DateTime(2026, 10, 1),
      );
      expect(income, 50000);
    });

    test('returns 0 when nothing matches', () async {
      final sum = await repository.sumByType(
        TransactionType.expense,
        from: DateTime(2026, 9, 1),
        to: DateTime(2026, 10, 1),
      );
      expect(sum, 0);
    });
  });

  group('categoryTotals', () {
    test('groups expenses by category, highest first, income excluded', () async {
      await add(amountMinor: 1000, category: 'Food');
      await add(amountMinor: 500, category: 'Food');
      await add(amountMinor: 4000, category: 'Bills');
      await add(amountMinor: 90000, category: 'Bills', type: TransactionType.income);

      final totals = await repository.categoryTotals(
        from: DateTime(2026, 9, 1),
        to: DateTime(2026, 10, 1),
      );
      expect(totals, [
        const CategoryTotal(category: 'Bills', amountMinor: 4000),
        const CategoryTotal(category: 'Food', amountMinor: 1500),
      ]);
    });
  });

  group('lastMethod', () {
    test('returns the method on the most recently dated transaction', () async {
      await add(
        amountMinor: 100,
        date: DateTime(2026, 9, 1),
        method: TransactionMethod.cash,
      );
      await add(
        amountMinor: 200,
        date: DateTime(2026, 9, 3),
        method: TransactionMethod.upi,
      );
      expect(await repository.lastMethod(), TransactionMethod.upi);
    });

    test('returns null when no transaction has a method', () async {
      await add(amountMinor: 100);
      expect(await repository.lastMethod(), isNull);
    });
  });
}
