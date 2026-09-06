import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/utils/clock.dart';
import '../domain/dashboard_section_repository.dart';
import '../domain/entities/dashboard_section.dart';

part 'dashboard_section_repository_impl.g.dart';

/// Appendix A's screen-content order, and the order new installs start with.
const List<HomeSectionKey> defaultSectionOrder = [
  HomeSectionKey.attention,
  HomeSectionKey.today,
  HomeSectionKey.upcoming,
  HomeSectionKey.quickAccess,
  HomeSectionKey.recent,
];

class DriftDashboardSectionRepository implements DashboardSectionRepository {
  DriftDashboardSectionRepository(this._db, this._clock);

  final AppDatabase _db;
  final Clock _clock;

  @override
  Stream<List<DashboardSection>> watchSections() async* {
    await _ensureSeeded();
    final query = _db.select(_db.dashboardSections)
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    yield* query.watch().map(
          (rows) => [for (final row in rows) _toDomain(row)],
        );
  }

  @override
  Future<void> setEnabled(HomeSectionKey key, {required bool enabled}) async {
    await _ensureSeeded();
    await (_db.update(_db.dashboardSections)
          ..where((t) => t.key.equals(key.name)))
        .write(
      DashboardSectionsCompanion(
        enabled: Value(enabled),
        updatedAt: Value(_clock.now()),
      ),
    );
  }

  @override
  Future<void> reorder(List<HomeSectionKey> order) async {
    await _ensureSeeded();
    final now = _clock.now();
    await _db.transaction(() async {
      for (final (index, key) in order.indexed) {
        await (_db.update(_db.dashboardSections)
              ..where((t) => t.key.equals(key.name)))
            .write(
          DashboardSectionsCompanion(
            sortOrder: Value(index),
            updatedAt: Value(now),
          ),
        );
      }
    });
  }

  Future<void> _ensureSeeded() async {
    final now = _clock.now();
    for (final (index, key) in defaultSectionOrder.indexed) {
      await _db.into(_db.dashboardSections).insert(
            DashboardSectionsCompanion.insert(
              key: key.name,
              sortOrder: index,
              updatedAt: now,
            ),
            mode: InsertMode.insertOrIgnore,
          );
    }
  }

  DashboardSection _toDomain(DashboardSectionRow row) => DashboardSection(
        key: HomeSectionKey.values.byName(row.key),
        enabled: row.enabled,
        sortOrder: row.sortOrder,
      );
}

@Riverpod(keepAlive: true)
DashboardSectionRepository dashboardSectionRepository(Ref ref) =>
    DriftDashboardSectionRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(clockProvider),
    );
