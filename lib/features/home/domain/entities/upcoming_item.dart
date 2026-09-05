import 'package:freezed_annotation/freezed_annotation.dart';

import 'home_item_kind.dart';

part 'upcoming_item.freezed.dart';

/// One row in Home's "Upcoming" section.
@freezed
abstract class UpcomingItem with _$UpcomingItem {
  const factory UpcomingItem({
    required String id,
    required HomeItemKind kind,
    required String title,
    required DateTime date,
  }) = _UpcomingItem;
}
