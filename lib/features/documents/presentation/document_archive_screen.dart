import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/state/toast_controller.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/document_repository_impl.dart';
import 'controllers/document_providers.dart';
import 'document_labels.dart';

/// The Archive list (section 6.8's "Added" screen). Archived documents are
/// still readable and still openable — archiving files something away, it does
/// not destroy it.
class DocumentArchiveScreen extends ConsumerWidget {
  const DocumentArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archived = ref.watch(archivedDocumentsProvider);
    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Archived documents')),
      body: archived.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(horizontal: KoshaSpace.screen),
          child: SkeletonList(),
        ),
        error: (error, _) => const EmptyState(
          icon: Symbols.error_rounded,
          title: "Couldn't load the archive",
          body: 'Something went wrong reading the database.',
        ),
        data: (list) => list.isEmpty
            ? const EmptyState(
                icon: Symbols.inventory_2_rounded,
                title: 'Nothing archived',
                body: 'Documents you archive are kept here, files and all.',
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  KoshaSpace.screen,
                  KoshaSpace.md,
                  KoshaSpace.screen,
                  KoshaSpace.xxxl,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final document = list[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: KoshaSpace.sm),
                    child: Material(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(KoshaRadius.card),
                      child: InkWell(
                        onTap: () =>
                            context.go(Routes.documentDetail(document.id)),
                        borderRadius: BorderRadius.circular(KoshaRadius.card),
                        child: Container(
                          padding: const EdgeInsets.all(KoshaSpace.md),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(KoshaRadius.card),
                            border: Border.all(color: c.hair),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                documentCategoryIcon(document.category),
                                color: c.text3,
                              ),
                              const SizedBox(width: KoshaSpace.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      document.name,
                                      style: t.bodyMedium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Archived '
                                      '${Dates.dayMonth(document.archivedAt!)}',
                                      style: t.bodySmall
                                          ?.copyWith(color: c.text3),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () => unawaited(
                                  _restore(context, ref, document.id,
                                      document.name),
                                ),
                                child: const Text('Restore'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _restore(
    BuildContext context,
    WidgetRef ref,
    String id,
    String name,
  ) async {
    await ref.read(documentRepositoryProvider).restore(id);
    if (!context.mounted) return;
    ref.read(toastControllerProvider.notifier).show('Restored “$name”');
  }
}
