import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/app_database.dart';
import '../../../core/utils/clock.dart';
import '../../onboarding/data/profile_repository_impl.dart';
import '../../onboarding/domain/profile_repository.dart';
import '../domain/entities/space.dart';
import '../domain/space_repository.dart';

part 'space_repository_impl.g.dart';

/// SQLite-backed spaces.
class DriftSpaceRepository implements SpaceRepository {
  DriftSpaceRepository(this._db, this._clock, this._profiles);

  static const Uuid _uuid = Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final ProfileRepository _profiles;

  @override
  Stream<List<Space>> watchActive() async* {
    await _ensureSeeded();
    yield* (_db.select(_db.spaces)..where((s) => s.archivedAt.isNull()))
        .map(_toDomain)
        .watch()
        .map(_sorted);
  }

  @override
  Future<List<Space>> listActive() async {
    await _ensureSeeded();
    final rows = await (_db.select(_db.spaces)
          ..where((s) => s.archivedAt.isNull()))
        .map(_toDomain)
        .get();
    return _sorted(rows);
  }

  @override
  Stream<List<Space>> watchArchived() async* {
    await _ensureSeeded();
    yield* (_db.select(_db.spaces)
          ..where((s) => s.archivedAt.isNotNull())
          ..orderBy([(s) => OrderingTerm.desc(s.archivedAt)]))
        .map(_toDomain)
        .watch();
  }

  @override
  Stream<List<Space>> watchHolding(SpaceHolds kind) =>
      // Holds are a converted text column, so the filter cannot be pushed into
      // SQL without matching on the encoding — a LIKE '%tasks%' would also hit
      // a future hold kind whose name contained another's. Ten-odd rows filter
      // in Dart for nothing.
      watchActive().map(
        (spaces) => [
          for (final space in spaces)
            if (space.holdsKind(kind)) space,
        ],
      );

  @override
  Future<Space?> findById(String id) async {
    final row = await (_db.select(_db.spaces)..where((s) => s.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<Space?> findBySystemKey(SystemSpace key) async {
    await _ensureSeeded();
    final row = await (_db.select(_db.spaces)
          ..where((s) => s.systemKey.equalsValue(key)))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<Space> create(NewSpace draft) async {
    await _ensureSeeded();
    final now = _clock.now();
    final space = Space(
      id: _uuid.v4(),
      name: draft.name,
      kind: SpaceKind.custom,
      holds: draft.holds,
      iconKey: draft.iconKey,
      sortOrder: await _nextSortOrder(),
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.spaces).insert(_toRow(space));
    return space;
  }

  @override
  Future<Space> edit(
    String id, {
    String? name,
    String? iconKey,
    Set<SpaceHolds>? holds,
  }) async {
    await (_db.update(_db.spaces)..where((s) => s.id.equals(id))).write(
      SpacesCompanion(
        name: name == null ? const Value.absent() : Value(name),
        iconKey: iconKey == null ? const Value.absent() : Value(iconKey),
        holds: holds == null ? const Value.absent() : Value(holds),
        updatedAt: Value(_clock.now()),
      ),
    );
    final updated = await findById(id);
    if (updated == null) throw StateError('No space with id $id');
    return updated;
  }

  @override
  Future<void> reorder(List<String> orderedIds) async {
    final now = _clock.now();
    await _db.transaction(() async {
      for (final (index, id) in orderedIds.indexed) {
        await (_db.update(_db.spaces)..where((s) => s.id.equals(id))).write(
          SpacesCompanion(sortOrder: Value(index), updatedAt: Value(now)),
        );
      }
    });
  }

  @override
  Future<void> archive(String id) async {
    final now = _clock.now();
    await (_db.update(_db.spaces)..where((s) => s.id.equals(id))).write(
      SpacesCompanion(archivedAt: Value(now), updatedAt: Value(now)),
    );
  }

  @override
  Future<void> restore(String id) async {
    await (_db.update(_db.spaces)..where((s) => s.id.equals(id))).write(
      SpacesCompanion(
        archivedAt: const Value(null),
        updatedAt: Value(_clock.now()),
      ),
    );
  }

  @override
  Future<int> linkedItemCount(String id) async {
    final tasks = await _countLinked(
      _db.selectOnly(_db.tasks),
      _db.tasks.spaceId.equals(id) & _db.tasks.deletedAt.isNull(),
    );
    final bills = await _countLinked(
      _db.selectOnly(_db.bills),
      _db.bills.spaceId.equals(id) & _db.bills.deletedAt.isNull(),
    );
    final transactions = await _countLinked(
      _db.selectOnly(_db.transactions),
      _db.transactions.spaceId.equals(id) & _db.transactions.deletedAt.isNull(),
    );
    final events = await _countLinked(
      _db.selectOnly(_db.events),
      _db.events.spaceId.equals(id) & _db.events.deletedAt.isNull(),
    );
    return tasks + bills + transactions + events;
  }

  Future<int> _countLinked(
    JoinedSelectStatement<dynamic, dynamic> query,
    Expression<bool> filter,
  ) async {
    final count = countAll();
    query
      ..addColumns([count])
      ..where(filter);
    final row = await query.getSingleOrNull();
    return row?.read(count) ?? 0;
  }

  /// Seeds the ten system spaces exactly once — when the table has never held
  /// a system row, not when it currently holds none, so a user who archives
  /// every one of them is not handed them all back on the next read.
  ///
  /// Onboarding's "Pick areas" decides which start visible: an area the user
  /// did not pick seeds its space already archived, which the Spaces screen
  /// offers to bring back. That is the reading `onboarding/domain/area.dart`
  /// asked Phase 3 for — the selection is a starting visibility, not a
  /// permanent exclusion, so nothing is withheld, only folded away.
  ///
  /// Custom spaces are counted too, and deliberately: their presence means
  /// seeding has run before (nothing can create one otherwise, since every
  /// write path awaits this method first), so counting only system rows would
  /// re-seed for a user who archived the lot.
  Future<void> _ensureSeeded() async {
    final count = countAll();
    final query = _db.selectOnly(_db.spaces)..addColumns([count]);
    final existing = (await query.getSingleOrNull())?.read(count) ?? 0;
    if (existing > 0) return;

    final picked = await _profiles.visibleAreas();
    final now = _clock.now();
    await _db.batch((batch) {
      for (final (index, system) in SystemSpace.values.indexed) {
        final gates = system.gatedBy;
        final visible = gates.isEmpty || gates.any(picked.contains);
        batch.insert(
          _db.spaces,
          SpacesCompanion.insert(
            id: _uuid.v4(),
            name: system.label,
            kind: SpaceKind.system,
            systemKey: Value(system),
            holds: system.holds,
            sortOrder: index,
            iconKey: Value(system.iconKey),
            createdAt: now,
            updatedAt: now,
            archivedAt: Value(visible ? null : now),
          ),
        );
      }
    });
  }

  Future<int> _nextSortOrder() async {
    final max = _db.spaces.sortOrder.max();
    final query = _db.selectOnly(_db.spaces)..addColumns([max]);
    final row = await query.getSingleOrNull();
    return (row?.read(max) ?? -1) + 1;
  }

  /// Ordering lives in Dart, not in `ORDER BY`, because the grid's tiebreak is
  /// the seeded system order and two spaces created in the same millisecond
  /// (the seed batch writes ten) would otherwise come back in an order SQLite
  /// is free to vary between runs.
  List<Space> _sorted(List<Space> spaces) {
    final sorted = [...spaces];
    sorted.sort((a, b) {
      final bySort = a.sortOrder.compareTo(b.sortOrder);
      if (bySort != 0) return bySort;
      return a.name.compareTo(b.name);
    });
    return sorted;
  }

  Space _toDomain(SpaceRow row) => Space(
        id: row.id,
        name: row.name,
        kind: row.kind,
        systemKey: row.systemKey,
        holds: row.holds,
        sortOrder: row.sortOrder,
        iconKey: row.iconKey,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        archivedAt: row.archivedAt,
      );

  SpacesCompanion _toRow(Space space) => SpacesCompanion.insert(
        id: space.id,
        name: space.name,
        kind: space.kind,
        systemKey: Value(space.systemKey),
        holds: space.holds,
        sortOrder: space.sortOrder,
        iconKey: Value(space.iconKey),
        createdAt: space.createdAt,
        updatedAt: space.updatedAt,
        archivedAt: Value(space.archivedAt),
      );
}

@Riverpod(keepAlive: true)
SpaceRepository spaceRepository(Ref ref) => DriftSpaceRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(clockProvider),
      ref.watch(profileRepositoryProvider),
    );
