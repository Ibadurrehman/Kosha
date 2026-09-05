import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result.freezed.dart';

/// What kind of record a result points back to — Task today; Notes/Documents/
/// Finance/Spaces join once those features exist.
enum SearchResultKind { task }

/// One row of a search result, grouped by [kind] in the fixed order the
/// prototype specifies (Tasks · Documents · Finance · Spaces · Notes).
@freezed
abstract class SearchResult with _$SearchResult {
  const factory SearchResult({
    required String id,
    required SearchResultKind kind,
    required String title,
    required String subtitle,
  }) = _SearchResult;
}
