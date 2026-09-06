import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/app_database.dart';
import '../../../core/utils/clock.dart';
import '../domain/entities/transaction_category.dart';
import '../domain/transaction_category_repository.dart';

part 'transaction_category_repository_impl.g.dart';

/// SQLite-backed categories.
class DriftTransactionCategoryRepository
    implements TransactionCategoryRepository {
  DriftTransactionCategoryRepository(this._db, this._clock);

  static const Uuid _uuid = Uuid();

  final AppDatabase _db;
  final Clock _clock;

  @override
  Stream<List<TransactionCategory>> watchByKind(CategoryKind kind) async* {
    await _ensureSeeded(kind);
    yield* _liveQuery(kind).watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<List<TransactionCategory>> listByKind(CategoryKind kind) async {
    await _ensureSeeded(kind);
    final rows = await _liveQuery(kind).get();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<TransactionCategory?> findById(String id) async {
    final row = await (_db.select(_db.transactionCategories)
          ..where((c) => c.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<TransactionCategory> create({
    required String name,
    required CategoryKind kind,
    String? iconKey,
  }) async {
    await _ensureSeeded(kind);
    final now = _clock.now();
    final category = TransactionCategory(
      id: _uuid.v4(),
      name: name,
      kind: kind,
      iconKey: iconKey,
      sortOrder: await _nextSortOrder(kind),
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.transactionCategories).insert(_toRow(category));
    return category;
  }

  @override
  Future<int> rename(String id, String name) async {
    final existing = await findById(id);
    if (existing == null) throw StateError('No category with id $id');
    final now = _clock.now();

    return _db.transaction(() async {
      await (_db.update(_db.transactionCategories)
            ..where((c) => c.id.equals(id)))
          .write(
        TransactionCategoriesCompanion(
          name: Value(name),
          updatedAt: Value(now),
        ),
      );
      // Transactions carry the label, so the rename has to reach them or the
      // dashboard would keep grouping money under a name that no longer
      // exists. Deleted transactions are relabelled too: an undo restores a
      // row that should read the same way as its neighbours.
      return (_db.update(_db.transactions)
            ..where((t) => t.category.equals(existing.name)))
          .write(
        TransactionsCompanion(category: Value(name), updatedAt: Value(now)),
      );
    });
  }

  @override
  Future<TransactionCategory> setIcon(String id, String? iconKey) async {
    final now = _clock.now();
    await (_db.update(_db.transactionCategories)..where((c) => c.id.equals(id)))
        .write(
      TransactionCategoriesCompanion(
        iconKey: Value(iconKey),
        updatedAt: Value(now),
      ),
    );
    final updated = await findById(id);
    if (updated == null) throw StateError('No category with id $id');
    return updated;
  }

  @override
  Future<void> reorder(CategoryKind kind, List<String> orderedIds) async {
    final now = _clock.now();
    await _db.transaction(() async {
      for (final (index, id) in orderedIds.indexed) {
        await (_db.update(_db.transactionCategories)
              ..where((c) => c.id.equals(id) & c.kind.equalsValue(kind)))
            .write(
          TransactionCategoriesCompanion(
            sortOrder: Value(index),
            updatedAt: Value(now),
          ),
        );
      }
    });
  }

  @override
  Future<void> softDelete(String id) async {
    final now = _clock.now();
    await (_db.update(_db.transactionCategories)..where((c) => c.id.equals(id)))
        .write(
      TransactionCategoriesCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<void> restore(String id) async {
    await (_db.update(_db.transactionCategories)..where((c) => c.id.equals(id)))
        .write(
      TransactionCategoriesCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_clock.now()),
      ),
    );
  }

  @override
  Future<int> transactionCount(String id) async {
    final category = await findById(id);
    if (category == null) return 0;
    final count = _db.transactions.id.count();
    final query = _db.selectOnly(_db.transactions)
      ..addColumns([count])
      ..where(
        _db.transactions.deletedAt.isNull() &
            _db.transactions.category.equals(category.name),
      );
    final row = await query.getSingleOrNull();
    return row?.read(count) ?? 0;
  }

  SimpleSelectStatement<$TransactionCategoriesTable, CategoryRow> _liveQuery(
    CategoryKind kind,
  ) =>
      _db.select(_db.transactionCategories)
        ..where((c) => c.deletedAt.isNull() & c.kind.equalsValue(kind))
        ..orderBy([
          (c) => OrderingTerm.asc(c.sortOrder),
          (c) => OrderingTerm.asc(c.createdAt),
        ]);

  /// Seeds a kind's defaults exactly once — when it has never had a row, not
  /// when it currently has none. Deleted rows count, so a user who removes
  /// every category is not handed the defaults back on the next read.
  Future<void> _ensureSeeded(CategoryKind kind) async {
    final count = _db.transactionCategories.id.count();
    final query = _db.selectOnly(_db.transactionCategories)
      ..addColumns([count])
      ..where(_db.transactionCategories.kind.equalsValue(kind));
    final existing = (await query.getSingleOrNull())?.read(count) ?? 0;
    if (existing > 0) return;

    final now = _clock.now();
    final defaults = kind == CategoryKind.expense
        ? defaultExpenseCategories
        : defaultIncomeCategories;
    await _db.batch((batch) {
      for (final (index, (name, iconKey)) in defaults.indexed) {
        batch.insert(
          _db.transactionCategories,
          TransactionCategoriesCompanion.insert(
            id: _uuid.v4(),
            name: name,
            kind: kind,
            sortOrder: index,
            iconKey: Value(iconKey),
            createdAt: now,
            updatedAt: now,
          ),
        );
      }
    });
  }

  Future<int> _nextSortOrder(CategoryKind kind) async {
    final max = _db.transactionCategories.sortOrder.max();
    final query = _db.selectOnly(_db.transactionCategories)
      ..addColumns([max])
      ..where(_db.transactionCategories.kind.equalsValue(kind));
    final row = await query.getSingleOrNull();
    return (row?.read(max) ?? -1) + 1;
  }

  TransactionCategory _toDomain(CategoryRow row) => TransactionCategory(
        id: row.id,
        name: row.name,
        kind: row.kind,
        sortOrder: row.sortOrder,
        iconKey: row.iconKey,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  TransactionCategoriesCompanion _toRow(TransactionCategory category) =>
      TransactionCategoriesCompanion.insert(
        id: category.id,
        name: category.name,
        kind: category.kind,
        sortOrder: category.sortOrder,
        iconKey: Value(category.iconKey),
        createdAt: category.createdAt,
        updatedAt: category.updatedAt,
      );
}

@Riverpod(keepAlive: true)
TransactionCategoryRepository transactionCategoryRepository(Ref ref) =>
    DriftTransactionCategoryRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(clockProvider),
    );
