import 'entities/needs_attention_item.dart';

/// One feature's contribution to Home's "Needs attention" section.
///
/// Only [TaskNeedsAttentionSource] (home/data) exists in Phase 1; Bills and
/// Documents add their own implementation later, merged in alongside it by
/// `needsAttentionProvider` — never a rewrite of this interface.
abstract interface class NeedsAttentionSource {
  Stream<List<NeedsAttentionItem>> watch({required DateTime today});
}
