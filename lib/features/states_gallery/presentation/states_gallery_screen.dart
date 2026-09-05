import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/models/priority.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/theme_mode_controller.dart';
import '../../../shared/widgets/widgets.dart';

/// Debug-only gallery of shared components and states. It doubles as the
/// fixture screen for golden tests, so keep every shared widget represented.
class StatesGalleryScreen extends ConsumerStatefulWidget {
  const StatesGalleryScreen({super.key});

  @override
  ConsumerState<StatesGalleryScreen> createState() => _StatesGalleryScreenState();
}

class _StatesGalleryScreenState extends ConsumerState<StatesGalleryScreen> {
  int _tab = 1;
  int _chip = 0;
  bool _toggle = true;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('States'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            icon: Icon(isDark ? Symbols.light_mode_rounded : Symbols.dark_mode_rounded),
            onPressed: () => ref
                .read(themeModeProvider.notifier)
                .set(isDark ? ThemeMode.light : ThemeMode.dark),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          const SectionLabel('Status pills'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final s in KoshaStatus.values) StatusPill(s)],
          ),
          const SizedBox(height: 24),
          const SectionLabel('Priority'),
          const Row(
            children: [
              PriorityDot(Priority.high),
              SizedBox(width: 12),
              PriorityDot(Priority.medium),
              SizedBox(width: 12),
              PriorityDot(Priority.low),
            ],
          ),
          const SizedBox(height: 24),
          const SectionLabel('Segmented tabs'),
          SegmentedTabs(
            labels: const ['Inbox', 'Today', 'Upcoming', 'Overdue', 'Completed'],
            selectedIndex: _tab,
            onChanged: (i) => setState(() => _tab = i),
          ),
          const SizedBox(height: 24),
          const SectionLabel('Chips'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (i, l) in ['All', 'Identity', 'Financial', 'Insurance'].indexed)
                KoshaChip(
                  label: l,
                  selected: i == _chip,
                  onTap: () => setState(() => _chip = i),
                ),
              KoshaChip(
                label: 'Today',
                icon: Symbols.event_rounded,
                selected: true,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SectionLabel('Toggle and progress'),
          Row(
            children: [
              KoshaToggle(
                value: _toggle,
                onChanged: (v) => setState(() => _toggle = v),
                semanticLabel: 'Toggle section',
              ),
              const SizedBox(width: 16),
              const Expanded(child: ProgressBar(value: 0.63)),
              const SizedBox(width: 12),
              Expanded(child: ProgressBar(value: 0.3, color: c.warning)),
            ],
          ),
          const SizedBox(height: 24),
          const SectionLabel('Buttons'),
          FilledButton(onPressed: () {}, child: const Text('Primary')),
          const SizedBox(height: 10),
          const FilledButton(onPressed: null, child: Text('Disabled')),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: () {}, child: const Text('Secondary')),
          const SizedBox(height: 24),
          const SectionLabel('Input'),
          const TextField(decoration: InputDecoration(hintText: 'What needs doing?')),
          const SizedBox(height: 24),
          const SectionLabel('Icon tiles'),
          const Row(
            children: [
              IconTile(Symbols.account_balance_wallet_rounded),
              SizedBox(width: 10),
              IconTile(Symbols.folder_shared_rounded, size: 46),
              SizedBox(width: 10),
              IconTile(Symbols.directions_car_rounded, size: 56),
            ],
          ),
          const SizedBox(height: 24),
          const SectionLabel('Empty · Today'),
          _Framed(
            child: EmptyState(
              icon: Symbols.task_alt_rounded,
              title: 'Nothing planned for today',
              body: "You're all caught up.",
              actionLabel: 'Add task',
              onAction: () {},
            ),
          ),
          const SizedBox(height: 24),
          const SectionLabel('Loading · skeleton'),
          const SkeletonList(),
          const SizedBox(height: 24),
          const SectionLabel('Error · network'),
          _Framed(
            child: EmptyState(
              icon: Symbols.wifi_off_rounded,
              tone: c.error,
              title: "You're offline",
              body: "Everything you add is saved on this phone and will sync when you're back.",
              actionLabel: 'Try again',
              onAction: () {},
            ),
          ),
          const SizedBox(height: 24),
          const SectionLabel('FAB'),
          Align(alignment: Alignment.centerLeft, child: KoshaFab(onPressed: () {})),
        ],
      ),
    );
  }
}

class _Framed extends StatelessWidget {
  const _Framed({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
