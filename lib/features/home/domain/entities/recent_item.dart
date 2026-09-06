import 'package:freezed_annotation/freezed_annotation.dart';

import 'home_item_kind.dart';

part 'recent_item.freezed.dart';

/// One row in Home's "Recent" section — the last 10 created/updated items
/// across every source, newest first.
@freezed
abstract class RecentItem with _$RecentItem {
  const factory RecentItem({
    required String id,
    required HomeItemKind kind,
    required String title,
    required String subtitle,
    required DateTime at,
  }) = _RecentItem;
}
