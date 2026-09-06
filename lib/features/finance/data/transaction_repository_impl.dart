import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/app_database.dart';
import '../../../core/utils/clock.dart';
import '../domain/entities/transaction.dart';
import '../domain/transaction_repository.dart';

part 'transaction_repository_impl.g.dart';

/// SQLite-backed transactions.
class DriftTransactionRepository implements TransactionRepository {
  DriftTransactionRepository(this._db, this._clock);

  static const Uuid _uuid = Uuid();

  final AppDatabase _db;
  final Clock _clock;

  @override
  Stream<List<Transaction>> watchRecent({required int limit}) {
    final query = _db.select(_db.transactions)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.date)])
      ..limit(limit);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<List<Transaction>> watchBetween(DateTime from, DateTime to) {
    final query = _db.select(_db.transactions)
      ..where(
        (t) =>
            t.deletedAt.isNull() &
            t.date.isBiggerOrEqualValue(from) &
            t.date.isSmallerThanValue(to),
      )
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<Transaction?> findById(String id) async {
    final row = await (_db.select(_db.transactions)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<Transaction> create(NewTransaction draft) async {
    final now = _clock.now();
    final transaction = Transaction(
      id: _uuid.v4(),
      amountMinor: draft.amountMinor,
      type: draft.type,
      date: draft.date,
      category: draft.category,
      method: draft.method,
      label: draft.label,
      note: draft.note,
      spaceId: draft.spaceId,
      billId: draft.billId,
      vehicleId: draft.vehicleId,
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.transactions).insert(_toRow(transaction));
    return transaction;
  }

  @override
  Future<Transaction> save(Transaction transaction) async {
    final existing = await _require(transaction.id);
    final updated = transaction.copyWith(
      createdAt: existing.createdAt,
      updatedAt: _clock.now(),
    );
    await _db.update(_db.transactions).replace(_toRow(updated));
    return updated;
  }

  @override
  Future<void> softDelete(String id) async {
    final now = _clock.now();
    await (_db.update(_db.transactions)..where((t) => t.id.equals(id)))
        .write(TransactionsCompanion(deletedAt: Value(now), updatedAt: Value(now)));
  }

  @override
  Future<void> restore(String id) async {
    await (_db.update(_db.transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_clock.now()),
      ),
    );
  }

  @override
  Future<void> purge(String id) async {
    await (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<int> sumByType(
    TransactionType type, {
    required DateTime from,
    required DateTime to,
  }) async {
    final sum = _db.transactions.amountMinor.sum();
    final query = _db.selectOnly(_db.transactions)
      ..addColumns([sum])
      ..where(
        _db.transactions.deletedAt.isNull() &
            _db.transactions.type.equalsValue(type) &
            _db.transactions.date.isBiggerOrEqualValue(from) &
            _db.transactions.date.isSmallerThanValue(to),
      );
    final row = await query.getSingleOrNull();
    return row?.read(sum) ?? 0;
  }

  @override
  Future<List<CategoryTotal>> categoryTotals({
    required DateTime from,
    required DateTime to,
  }) async {
    final sum = _db.transactions.amountMinor.sum();
    final category = _db.transactions.category;
    final query = _db.selectOnly(_db.transactions)
      ..addColumns([category, sum])
      ..where(
        _db.transactions.deletedAt.isNull() &
            _db.transactions.type.equalsValue(TransactionType.expense) &
            _db.transactions.category.isNotNull() &
            _db.transactions.date.isBiggerOrEqualValue(from) &
            _db.transactions.date.isSmallerThanValue(to),
      )
      ..groupBy([category])
      ..orderBy([OrderingTerm.desc(sum)]);
    final rows = await query.get();
    return [
      for (final row in rows)
        CategoryTotal(
          category: row.read(category)!,
          amountMinor: row.read(sum) ?? 0,
        ),
    ];
  }

  @override
  Future<TransactionMethod?> lastMethod() async {
    final row = await (_db.select(_db.transactions)
          ..where((t) => t.deletedAt.isNull() & t.method.isNotNull())
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(1))
        .getSingleOrNull();
    return row?.method;
  }

  Future<Transaction> _require(String id) async {
    final transaction = await findById(id);
    if (transaction == null) throw StateError('No transaction with id $id');
    return transaction;
  }

  Transaction _toDomain(TransactionRow row) => Transaction(
        id: row.id,
        amountMinor: row.amountMinor,
        type: row.type,
        date: row.date,
        category: row.category,
        method: row.method,
        label: row.label,
        note: row.note,
        spaceId: row.spaceId,
        billId: row.billId,
        vehicleId: row.vehicleId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  TransactionRow _toRow(Transaction transaction) => TransactionRow(
        id: transaction.id,
        amountMinor: transaction.amountMinor,
        type: transaction.type,
        date: transaction.date,
        category: transaction.category,
        method: transaction.method,
        label: transaction.label,
        note: transaction.note,
        spaceId: transaction.spaceId,
        billId: transaction.billId,
        vehicleId: transaction.vehicleId,
        createdAt: transaction.createdAt,
        updatedAt: transaction.updatedAt,
      );
}

@Riverpod(keepAlive: true)
TransactionRepository transactionRepository(Ref ref) => DriftTransactionRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(clockProvider),
    );
