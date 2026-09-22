import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/clock.dart';
import '../../../shared/widgets/widgets.dart';
import '../domain/entities/document.dart';
import 'controllers/document_providers.dart';
import 'document_labels.dart';
import 'widgets/document_tile.dart';
import 'widgets/new_document_sheet.dart';

/// The Documents screen (section 6.8): eight category chips over a two-column
/// grid of tiles, each with a status pill.
class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documents = ref.watch(documentsProvider);
    final counts = ref.watch(documentCategoryCountsProvider).value ?? const {};
    final urgent = ref.watch(documentsNeedingAttentionProvider).value ?? const [];
    final selected = ref.watch(documentFilterProvider);
    final today = ref.watch(clockProvider).today();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
        actions: [
          IconButton(
            tooltip: 'Archive',
            onPressed: () => context.go(Routes.documentsArchive),
            icon: const Icon(Symbols.inventory_2_rounded),
          ),
        ],
      ),
      floatingActionButton: KoshaFab(
        onPressed: () => unawaited(showNewDocumentSheet(context)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (urgent.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                KoshaSpace.screen,
                0,
                KoshaSpace.screen,
                KoshaSpace.md,
              ),
              child: _AttentionLine(count: urgent.length),
            ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: KoshaSpace.screen,
              ),
              children: [
                for (final category in DocumentCategory.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: KoshaChip(
                      label: counts[category] == null
                          ? category.label
                          : '${category.label} ${counts[category]}',
                      icon: documentCategoryIcon(category),
                      selected: selected == category,
                      onTap: () => ref
                          .read(documentFilterProvider.notifier)
                          .toggle(category),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: KoshaSpace.md),
          Expanded(
            child: documents.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(horizontal: KoshaSpace.screen),
                child: SkeletonList(),
              ),
              error: (error, _) => EmptyState(
                icon: Symbols.error_rounded,
                title: "Couldn't load documents",
                body: 'Something went wrong reading the database.',
                actionLabel: 'Try again',
                onAction: () => ref.invalidate(documentsProvider),
              ),
              data: (list) => list.isEmpty
                  ? _Empty(category: selected, ref: ref)
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        KoshaSpace.screen,
                        0,
                        KoshaSpace.screen,
                        96,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: KoshaSpace.md,
                        crossAxisSpacing: KoshaSpace.md,
                        mainAxisExtent: 152,
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, index) => DocumentTile(
                        document: list[index],
                        today: today,
                        onTap: () => context.go(
                          Routes.documentDetail(list[index].id),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttentionLine extends StatelessWidget {
  const _AttentionLine({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Container(
      padding: const EdgeInsets.all(KoshaSpace.md),
      decoration: BoxDecoration(
        color: c.warningSoft,
        borderRadius: BorderRadius.circular(KoshaRadius.row),
      ),
      child: Row(
        children: [
          Icon(Symbols.error_rounded, size: 18, color: c.warning),
          const SizedBox(width: KoshaSpace.sm),
          Expanded(
            child: Text(
              count == 1
                  ? '1 document needs attention'
                  : '$count documents need attention',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: c.warning),
            ),
          ),
        ],
      ),
    );
  }
}

/// The per-category empty state section 6.8 asks for: a filtered view that
/// finds nothing says so about *that* category, not about the app.
class _Empty extends StatelessWidget {
  const _Empty({required this.category, required this.ref});

  final DocumentCategory? category;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    if (category == null) {
      return EmptyState(
        icon: Symbols.folder_shared_rounded,
        title: 'No documents yet',
        body: 'Upload a file or scan a page, and Kosha will remind you before '
            'it expires.',
        actionLabel: 'Add a document',
        onAction: () => unawaited(showNewDocumentSheet(context)),
      );
    }
    return EmptyState(
      icon: documentCategoryIcon(category!),
      title: 'Nothing under ${category!.label}',
      body: 'Documents you file here will show up in this chip.',
      actionLabel: 'Show all documents',
      onAction: () => ref.read(documentFilterProvider.notifier).clear(),
    );
  }
}
