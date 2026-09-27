import '../../../core/router/app_router.dart';
import '../domain/entities/home_item_kind.dart';

/// Where a Home aggregator item's tap should go. The one place that maps
/// [HomeItemKind] to a real route — Home's sections themselves never know
/// about `Routes` directly, only about this function.
String homeItemRoute(HomeItemKind kind, String id) => switch (kind) {
      HomeItemKind.task => Routes.taskDetail(id),
      HomeItemKind.bill => Routes.billDetail(id),
      HomeItemKind.document => Routes.documentDetail(id),
    };
