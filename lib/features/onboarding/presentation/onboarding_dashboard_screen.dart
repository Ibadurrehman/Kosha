import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../shared/widgets/widgets.dart';
import '../../home/data/dashboard_section_repository_impl.dart';
import '../../home/presentation/controllers/home_providers.dart';
import '../../home/presentation/widgets/section_toggle_row.dart';
import 'widgets/onboarding_progress.dart';

/// Step 3 of 4. Each toggle writes straight through to
/// [DashboardSectionRepository] — the choice is live immediately, so
/// "Continue" only has to navigate on.
class OnboardingDashboardScreen extends ConsumerWidget {
  const OnboardingDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(dashboardSectionsProvider);
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: sections.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: KoshaSpace.screen),
                  child: SkeletonList(),
                ),
                error: (error, _) => const EmptyState(
                  icon: Symbols.error_rounded,
                  title: "Couldn't load your dashboard",
                  body: 'Something went wrong reading the database.',
                ),
                data: (list) => ListView(
                  padding: const EdgeInsets.fromLTRB(
                    KoshaSpace.screen,
                    0,
                    KoshaSpace.screen,
                    24,
                  ),
                  children: [
                    const OnboardingProgress(step: 3),
                    const SizedBox(height: 18),
                    Text('Choose your dashboard', style: t.headlineSmall),
                    const SizedBox(height: 6),
                    Text(
                      'Turn sections off if you don’t need them — you can '
                      'change this later too.',
                      style: t.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    for (final section in list)
                      SectionToggleRow(
                        section: section,
                        onChanged: (enabled) => ref
                            .read(dashboardSectionRepositoryProvider)
                            .setEnabled(section.key, enabled: enabled),
                      ),
                  ],
                ),
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
                onPressed: () => context.go(Routes.onboarding4),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
