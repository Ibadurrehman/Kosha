import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/search_repository_impl.dart';
import '../../domain/search_filter.dart';
import '../../domain/search_result.dart';

part 'search_providers.g.dart';

/// The database layer stays fully reactive; the screen debounces keystrokes
/// (~250 ms) before updating [query] so a live-typed search doesn't requery
/// on every character.
@riverpod
Stream<List<SearchResult>> searchResults(Ref ref, String query, SearchFilter filter) =>
    ref.watch(searchRepositoryProvider).search(query, filter: filter);

@riverpod
Future<List<String>> recentSearches(Ref ref) =>
    ref.watch(searchRepositoryProvider).recentSearches();

@riverpod
class SelectedSearchFilter extends _$SelectedSearchFilter {
  @override
  SearchFilter build() => SearchFilter.everything;

  void select(SearchFilter filter) => state = filter;
}
