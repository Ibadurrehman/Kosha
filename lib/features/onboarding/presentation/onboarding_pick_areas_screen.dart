import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../data/profile_repository_impl.dart';
import '../domain/area.dart';
import 'controllers/onboarding_providers.dart';
import 'widgets/onboarding_progress.dart';

const Map<OnboardingArea, IconData> _areaIcons = {
  OnboardingArea.tasks: Symbols.task_alt_rounded,
  OnboardingArea.finance: Symbols.account_balance_wallet_rounded,
  OnboardingArea.bills: Symbols.receipt_long_rounded,
  OnboardingArea.documents: Symbols.folder_shared_rounded,
  OnboardingArea.shopping: Symbols.shopping_basket_rounded,
  OnboardingArea.home: Symbols.home_work_rounded,
  OnboardingArea.vehicle: Symbols.directions_car_rounded,
  OnboardingArea.goals: Symbols.flag_rounded,
  OnboardingArea.notes: Symbols.sticky_note_2_rounded,
};

/// Step 2 of 4. Spaces don't exist yet (Phase 3), so this only narrows what
/// Home talks about — nothing here creates or hides a real row.
class OnboardingPickAreasScreen extends ConsumerWidget {
  const OnboardingPickAreasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedAreasProvider);
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  KoshaSpace.screen,
                  0,
                  KoshaSpace.screen,
                  24,
                ),
                children: [
                  const OnboardingProgress(step: 2),
                  const SizedBox(height: 18),
                  Text('What do you want to track?', style: t.headlineSmall),
                  const SizedBox(height: 6),
                  Text(
                    'Pick what matters to you — you can change this any time '
                    'from Settings.',
                    style: t.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.92,
                    children: [
                      for (final area in OnboardingArea.values)
                        _AreaTile(
                          area: area,
                          selected: selected.contains(area),
                          onTap: () => ref
                              .read(selectedAreasProvider.notifier)
                              .toggle(area),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                KoshaSpace.screen,
                0,
                KoshaSpace.screen,
                20,
              ),
              child: FilledButton(
                onPressed: () => unawaited(_continue(context, ref, selected)),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _continue(
    BuildContext context,
    WidgetRef ref,
    Set<OnboardingArea> selected,
  ) async {
    await ref.read(profileRepositoryProvider).setVisibleAreas(selected);
    if (context.mounted) context.go(Routes.onboarding3);
  }
}

class _AreaTile extends StatelessWidget {
  const _AreaTile({
    required this.area,
    required this.selected,
    required this.onTap,
  });

  final OnboardingArea area;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? c.accentSoft : c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KoshaRadius.card),
          side: BorderSide(color: selected ? c.accent : c.border),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(KoshaRadius.card),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _areaIcons[area],
                  size: 24,
                  color: selected ? c.accent : c.text2,
                ),
                const SizedBox(height: 8),
                Text(
                  area.label,
                  style: t.labelLarge?.copyWith(
                    color: selected ? c.accent : c.text,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
