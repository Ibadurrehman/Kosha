import 'search_filter.dart';
import 'search_result.dart';

/// Full-text search over whatever this phase has indexed (Tasks only).
abstract interface class SearchRepository {
  /// True when [filter] is backed by a real index. The screen uses this to
  /// tell "not built yet" apart from "no matches".
  bool supports(SearchFilter filter);

  /// Empty for a blank [query] or an unsupported [filter], without erroring.
  Stream<List<SearchResult>> search(String query, {required SearchFilter filter});

  /// Last 5 non-blank queries, most recent first.
  Future<List<String>> recentSearches();

  Future<void> recordSearch(String query);
}
