import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../shared/state/toast_controller.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/space_repository_impl.dart';
import '../domain/entities/space.dart';
import '../domain/entities/space_summary.dart';
import 'controllers/space_providers.dart';
import 'space_icons.dart';
import 'widgets/custom_records_card.dart';
import 'widgets/new_space_sheet.dart';
import 'widgets/space_tile.dart';

/// The Spaces grid (section 6.5): every space the user keeps, with a live
/// sub-line, plus the tile that makes a new one.
class SpacesScreen extends ConsumerWidget {
  const SpacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spaces = ref.watch(activeSpacesProvider);
    final summaries = ref.watch(spaceSummariesProvider);
    final archived = ref.watch(archivedSpacesProvider);
    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Spaces')),
      body: spaces.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(horizontal: KoshaSpace.screen),
          child: SkeletonList(),
        ),
        error: (error, _) => EmptyState(
          icon: Symbols.error_rounded,
          title: "Couldn't load spaces",
          body: 'Something went wrong reading the database.',
          actionLabel: 'Try again',
          onAction: () => ref.invalidate(activeSpacesProvider),
        ),
        data: (list) => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                KoshaSpace.screen,
                0,
                KoshaSpace.screen,
                KoshaSpace.lg,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Everything you keep, grouped by the part of life it '
                  'belongs to.',
                  style: t.bodyMedium?.copyWith(color: c.text2),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: KoshaSpace.screen,
              ),
              sliver: SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: KoshaSpace.md,
                  crossAxisSpacing: KoshaSpace.md,
                  // Tall enough for two lines of sub-line at 130% text scale,
                  // which §7.6 asks these screens to survive.
                  mainAxisExtent: 148,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == list.length) {
                      return NewSpaceTile(
                        onTap: () => unawaited(_create(context, ref)),
                      );
                    }
                    final space = list[index];
                    return SpaceTile(
                      space: space,
                      summary: summaries.value?[space.id] ??
                          SpaceSummary.empty,
                      onTap: () => _open(context, space),
                      onLongPress: () =>
                          unawaited(_archive(context, ref, space)),
                    );
                  },
                  childCount: list.length + 1,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: CustomRecordsCard()),
            SliverToBoxAdapter(
              child: _ArchivedFooter(
                spaces: archived.value ?? const [],
                onRestore: (space) => unawaited(_restore(context, ref, space)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, Space space) =>
      context.go(Routes.spaceDetail(space.id));

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final result = await showNewSpaceSheet(context);
    if (result == null || !context.mounted) return;

    final repository = ref.read(spaceRepositoryProvider);
    final space = await repository.create(
      NewSpace(
        name: result.name,
        holds: result.holds,
        iconKey: result.iconKey,
      ),
    );
    ref.read(toastControllerProvider.notifier).show(
          'Created “${space.name}”',
          onUndo: () => unawaited(repository.archive(space.id)),
        );
  }

  Future<void> _archive(
    BuildContext context,
    WidgetRef ref,
    Space space,
  ) async {
    final repository = ref.read(spaceRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    final linked = await repository.linkedItemCount(space.id);
    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Archive “${space.name}”?'),
        content: Text(
          linked == 0
              ? 'It leaves the grid. You can bring it back at any time.'
              : 'It leaves the grid, and the $linked item'
                  '${linked == 1 ? '' : 's'} inside it stop showing a space. '
                  'Nothing is deleted — bringing the space back brings the '
                  'links with it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep it'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await repository.archive(space.id);
    toast.show(
      'Archived “${space.name}”',
      onUndo: () => unawaited(repository.restore(space.id)),
    );
  }

  Future<void> _restore(
    BuildContext context,
    WidgetRef ref,
    Space space,
  ) async {
    await ref.read(spaceRepositoryProvider).restore(space.id);
    if (!context.mounted) return;
    ref.read(toastControllerProvider.notifier).show('Brought “${space.name}” back');
  }
}

/// The footer that offers archived spaces back.
///
/// Onboarding's "Pick areas" is why this is not a rare, tucked-away state: a
/// user who picked five areas has four system spaces sitting here on first
/// run, and the only way they learn Vehicle exists is by being shown it.
class _ArchivedFooter extends StatelessWidget {
  const _ArchivedFooter({required this.spaces, required this.onRestore});

  final List<Space> spaces;
  final void Function(Space) onRestore;

  @override
  Widget build(BuildContext context) {
    if (spaces.isEmpty) return const SizedBox(height: KoshaSpace.xxxl);

    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        KoshaSpace.screen,
        KoshaSpace.xxl,
        KoshaSpace.screen,
        KoshaSpace.xxxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(
            'Not shown',
            trailing: Text(
              '${spaces.length} hidden',
              style: t.bodySmall?.copyWith(color: c.text3),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(height: KoshaSpace.sm),
          Text(
            'Spaces you archived, and the areas you skipped during setup.',
            style: t.bodySmall?.copyWith(color: c.text3),
          ),
          const SizedBox(height: KoshaSpace.md),
          for (final space in spaces)
            Padding(
              padding: const EdgeInsets.only(bottom: KoshaSpace.sm),
              child: Row(
                children: [
                  Icon(spaceIcon(space.iconKey), size: 20, color: c.text3),
                  const SizedBox(width: KoshaSpace.md),
                  Expanded(
                    child: Text(space.name, style: t.bodyMedium),
                  ),
                  TextButton(
                    onPressed: () => onRestore(space),
                    child: const Text('Show'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
