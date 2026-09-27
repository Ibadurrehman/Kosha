import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/clock.dart';
import '../../data/document_repository_impl.dart';
import '../../domain/entities/attachment.dart';
import '../../domain/entities/document.dart';

part 'document_providers.g.dart';

/// The category chip the Documents screen is filtered by; null is "All".
@riverpod
class DocumentFilter extends _$DocumentFilter {
  @override
  DocumentCategory? build() => null;

  /// Tapping the selected chip again clears the filter, the way the expense
  /// sheet's category chips already behave.
  void toggle(DocumentCategory category) =>
      state = state == category ? null : category;

  void clear() => state = null;
}

@riverpod
Stream<List<Document>> documents(Ref ref) => ref
    .watch(documentRepositoryProvider)
    .watchAll(category: ref.watch(documentFilterProvider));

/// Counts per chip. Unfiltered on purpose: a chip that said "0" only because
/// another chip is selected would be lying about what is in the app.
@riverpod
Stream<Map<DocumentCategory, int>> documentCategoryCounts(Ref ref) =>
    ref.watch(documentRepositoryProvider).watchCategoryCounts();

@riverpod
Stream<List<Document>> archivedDocuments(Ref ref) =>
    ref.watch(documentRepositoryProvider).watchArchived();

/// One document for the detail screen; emits null once it is archived, which
/// is what sends the screen back rather than leaving a stale header up.
@riverpod
Stream<Document?> documentById(Ref ref, String id) =>
    ref.watch(documentRepositoryProvider).watchById(id);

@riverpod
Stream<List<Attachment>> documentAttachments(Ref ref, String documentId) =>
    ref.watch(documentRepositoryProvider).watchAttachments(documentId);

/// Documents that are expired or inside their own lead time — Home's Needs
/// attention reads this through its adapter, and Documents' own list uses it
/// for the "n need attention" line.
@riverpod
Stream<List<Document>> documentsNeedingAttention(Ref ref) => ref
    .watch(documentRepositoryProvider)
    .watchNeedingAttention(today: ref.watch(clockProvider).today());
