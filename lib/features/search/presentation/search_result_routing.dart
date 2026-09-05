import '../../../core/router/app_router.dart';
import '../domain/search_result.dart';

/// Where a search result's tap should go — the one place that maps
/// [SearchResultKind] to a real route.
String searchResultRoute(SearchResultKind kind, String id) => switch (kind) {
      SearchResultKind.task => Routes.taskDetail(id),
    };
