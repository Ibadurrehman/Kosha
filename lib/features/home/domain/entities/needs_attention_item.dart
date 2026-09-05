import 'package:freezed_annotation/freezed_annotation.dart';

import 'home_item_kind.dart';

part 'needs_attention_item.freezed.dart';

/// One row in Home's "Needs attention" section.
@freezed
abstract class NeedsAttentionItem with _$NeedsAttentionItem {
  const factory NeedsAttentionItem({
    required String id,
    required HomeItemKind kind,
    required String title,
    required String subtitle,

    /// "View" today; a bill would say "Pay" (section 6.2).
    required String ctaLabel,
  }) = _NeedsAttentionItem;
}
