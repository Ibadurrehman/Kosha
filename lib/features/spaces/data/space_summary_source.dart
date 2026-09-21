import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/utils/clock.dart';
import '../../../core/utils/combine_streams.dart';
import '../../finance/domain/entities/transaction.dart';
import '../domain/entities/space_summary.dart';

part 'space_summary_source.g.dart';

/// Counts the items that point at each space, for the grid's sub-lines
/// ("₹42,500 spent · 3 bills", section 6.5).
///
/// One grouped query per figure over the whole table rather than one query per
/// space: the grid asks about every tile at once, so a per-space read would be
/// N round trips scanning the same rows. A space with nothing in it simply
/// does not come back and reads as empty.
///
/// Documents, notes and lists are absent because their tables are. Adding one
/// is a fourth entry in the list passed to [combineLatestLists] plus a
/// [SpaceTallyKind] — the merge point this file is built on exists so a later
/// phase adds a source instead of rewriting the aggregation (plan §12.1.3).
class SpaceSummarySource {
  const SpaceSummarySource(this._db, this._clock);

  final AppDatabase _db;
  final Clock _clock;

  /// Live summaries keyed by space id.
  Stream<Map<String, SpaceSummary>> watchAll() {
    final today = _clock.today();
    final monthStart = DateTime(today.year, today.month);
    final monthEnd = DateTime(today.year, today.month + 1);

    return combineLatestLists<SpaceTally>([
      _countBySpace(
        _db.tasks,
        _db.tasks.spaceId,
        _db.tasks.deletedAt.isNull() & _db.tasks.done.equals(false),
        SpaceTallyKind.openTasks,
      ),
      _countBySpace(
        _db.bills,
        _db.bills.spaceId,
        _db.bills.deletedAt.isNull(),
        SpaceTallyKind.bills,
      ),
      _sumBySpace(
        _db.transactions.deletedAt.isNull() &
            _db.transactions.type.equalsValue(TransactionType.expense) &
            _db.transactions.date.isBiggerOrEqualValue(monthStart) &
            _db.transactions.date.isSmallerThanValue(monthEnd),
      ),
    ]).map(foldTallies);
  }

  Stream<List<SpaceTally>> _countBySpace(
    TableInfo<Table, dynamic> table,
    GeneratedColumn<String> spaceId,
    Expression<bool> filter,
    SpaceTallyKind kind,
  ) {
    final count = countAll();
    final query = _db.selectOnly(table)
      ..addColumns([spaceId, count])
      ..where(filter & spaceId.isNotNull())
      ..groupBy([spaceId]);
    return query.watch().map(
          (rows) => [
            for (final row in rows)
              if (row.read(spaceId) case final id?)
                SpaceTally(id, kind, row.read(count) ?? 0),
          ],
        );
  }

  Stream<List<SpaceTally>> _sumBySpace(Expression<bool> filter) {
    final spaceId = _db.transactions.spaceId;
    final total = _db.transactions.amountMinor.sum();
    final query = _db.selectOnly(_db.transactions)
      ..addColumns([spaceId, total])
      ..where(filter & spaceId.isNotNull())
      ..groupBy([spaceId]);
    return query.watch().map(
          (rows) => [
            for (final row in rows)
              if (row.read(spaceId) case final id?)
                SpaceTally(id, SpaceTallyKind.spentMinor, row.read(total) ?? 0),
          ],
        );
  }
}

@Riverpod(keepAlive: true)
SpaceSummarySource spaceSummarySource(Ref ref) => SpaceSummarySource(
      ref.watch(appDatabaseProvider),
      ref.watch(clockProvider),
    );
