import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/services/settings/settings_store.dart';
import '../../../core/utils/formatters.dart';
import '../domain/search_filter.dart';
import '../domain/search_query.dart';
import '../domain/search_repository.dart';
import '../domain/search_result.dart';

part 'search_repository_impl.g.dart';

const String _recentSearchesKey = 'search.recent';
const int _recentSearchesLimit = 5;

/// FTS5-backed search over `tasks_fts` (schema v8). Other filters are
/// recognised but not yet indexed — `supports()` is what lets the screen
/// distinguish that from a real empty result set.
class DriftSearchRepository implements SearchRepository {
  DriftSearchRepository(this._db, this._settings);

  static const int _resultLimit = 20;

  final AppDatabase _db;
  final SettingsStore _settings;

  @override
  bool supports(SearchFilter filter) =>
      filter == SearchFilter.everything || filter == SearchFilter.tasks;

  @override
  Stream<List<SearchResult>> search(String query, {required SearchFilter filter}) {
    if (!supports(filter)) return Stream.value(const []);
    final match = sanitizeSearchQuery(query);
    if (match.isEmpty) return Stream.value(const []);

    final ranked = _db.customSelect(
      'SELECT tasks.id AS id FROM tasks_fts '
      'JOIN tasks ON tasks.rowid = tasks_fts.rowid '
      'WHERE tasks_fts MATCH ?1 AND tasks.deleted_at IS NULL '
      'ORDER BY bm25(tasks_fts) LIMIT ?2',
      variables: [Variable.withString(match), Variable.withInt(_resultLimit)],
      readsFrom: {_db.tasks},
    );

    return ranked.watch().asyncMap((rows) async {
      final rankedIds = [for (final row in rows) row.read<String>('id')];
      if (rankedIds.isEmpty) return const <SearchResult>[];
      final taskRows =
          await (_db.select(_db.tasks)..where((t) => t.id.isIn(rankedIds))).get();
      final byId = {for (final row in taskRows) row.id: row};
      return [
        for (final id in rankedIds)
          if (byId[id] case final row?) _toResult(row),
      ];
    });
  }

  @override
  Future<List<String>> recentSearches() async {
    final stored = await _settings.read(
      _recentSearchesKey,
      (json) => (json as List).cast<String>(),
    );
    return stored ?? const [];
  }

  @override
  Future<void> recordSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final current = await recentSearches();
    final deduped = [
      trimmed,
      for (final past in current)
        if (past.toLowerCase() != trimmed.toLowerCase()) past,
    ];
    await _settings.write(_recentSearchesKey, deduped.take(_recentSearchesLimit).toList());
  }

  SearchResult _toResult(TaskRow row) => SearchResult(
        id: row.id,
        kind: SearchResultKind.task,
        title: row.title,
        subtitle: row.dueDate != null
            ? 'Due ${Dates.dayMonth(row.dueDate!)}'
            : (row.category ?? 'Task'),
      );
}

@Riverpod(keepAlive: true)
SearchRepository searchRepository(Ref ref) => DriftSearchRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(settingsStoreProvider),
    );
