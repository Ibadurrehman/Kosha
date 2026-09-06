import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../shared/state/toast_controller.dart';
import '../../../shared/widgets/widgets.dart';
import '../../home/data/dashboard_section_repository_impl.dart';
import '../../home/domain/entities/dashboard_section.dart';
import '../../home/presentation/controllers/home_providers.dart';
import '../../home/presentation/widgets/section_toggle_row.dart';

/// Toggle and drag-reorder Home's 5 sections, then Save.
///
/// Unlike onboarding's version of this list (which writes through on every
/// tap), this screen edits a local copy and only persists on "Save changes" —
/// matching the prototype, whose Customize dashboard has its own explicit
/// save action distinct from every other settings row's live toggle.
class CustomizeDashboardScreen extends ConsumerWidget {
  const CustomizeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(dashboardSectionsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Customize dashboard')),
      body: sections.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(KoshaSpace.screen),
          child: SkeletonList(),
        ),
        error: (error, _) => const EmptyState(
          icon: Symbols.error_rounded,
          title: "Couldn't load your dashboard",
          body: 'Something went wrong reading the database.',
        ),
        data: (list) => _Editor(initial: list),
      ),
    );
  }
}

class _Editor extends ConsumerStatefulWidget {
  const _Editor({required this.initial});

  final List<DashboardSection> initial;

  @override
  ConsumerState<_Editor> createState() => _EditorState();
}

class _EditorState extends ConsumerState<_Editor> {
  late List<DashboardSection> _sections = widget.initial;

  void _reorder(int oldIndex, int newIndex) {
    // `onReorderItem` (unlike the deprecated `onReorder`) already adjusts
    // newIndex for the removed item, so no manual index-shift is needed here.
    setState(() {
      final list = [..._sections];
      final moved = list.removeAt(oldIndex);
      list.insert(newIndex, moved);
      _sections = list;
    });
  }

  void _setEnabled(HomeSectionKey key, bool enabled) {
    setState(() {
      _sections = [
        for (final section in _sections)
          if (section.key == key) section.copyWith(enabled: enabled) else section,
      ];
    });
  }

  Future<void> _save() async {
    final repository = ref.read(dashboardSectionRepositoryProvider);
    await repository.reorder([for (final s in _sections) s.key]);
    for (final section in _sections) {
      await repository.setEnabled(section.key, enabled: section.enabled);
    }
    final shown = _sections.where((s) => s.enabled).length;
    if (!mounted) return;
    ref.read(toastControllerProvider.notifier).show(
          '$shown section${shown == 1 ? '' : 's'} shown on Home',
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Column(
      children: [
        Expanded(
          child: ReorderableListView(
            padding: const EdgeInsets.fromLTRB(
              KoshaSpace.screen,
              12,
              KoshaSpace.screen,
              24,
            ),
            onReorderItem: _reorder,
            children: [
              for (final section in _sections)
                Container(
                  key: ValueKey(section.key),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: c.hair)),
                  ),
                  child: SectionToggleRow(
                    section: section,
                    onChanged: (enabled) => _setEnabled(section.key, enabled),
                    dragHandle: Icon(
                      Symbols.drag_indicator_rounded,
                      color: c.text3,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: c.surface,
            border: Border(top: BorderSide(color: c.border)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: FilledButton(
                onPressed: () => unawaited(_save()),
                child: const Text('Save changes'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
