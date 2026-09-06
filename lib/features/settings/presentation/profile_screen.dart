import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/widgets.dart';
import '../../onboarding/domain/entities/profile.dart';
import '../../onboarding/presentation/controllers/onboarding_providers.dart';
import 'appearance_screen.dart';
import 'controllers/profile_stats_providers.dart';
import 'customize_dashboard_screen.dart';

/// Avatar, name, email, joined date; the two real "this month" stats; links
/// to Dashboard sections and Appearance (Export is still Phase 6).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profile.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(KoshaSpace.screen),
          child: SkeletonList(),
        ),
        error: (error, _) => const EmptyState(
          icon: Symbols.error_rounded,
          title: "Couldn't load your profile",
          body: 'Something went wrong reading the database.',
        ),
        data: (value) => _ProfileBody(profile: value),
      ),
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final completed = ref.watch(tasksCompletedThisMonthProvider);
    final added = ref.watch(tasksAddedThisMonthProvider);

    return ListView(
      padding: const EdgeInsets.all(KoshaSpace.screen),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: KoshaColors.avatarTones.first,
                child: Text(
                  profile.avatarInitials,
                  style: t.headlineSmall?.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              Text(profile.name, style: t.titleLarge),
              const SizedBox(height: 2),
              Text(
                [
                  if (profile.email case final email? when email.isNotEmpty) email,
                  'Joined ${Dates.dayMonthYear(profile.joinedAt)}',
                ].join(' · '),
                style: t.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionLabel('This month'),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                label: 'Tasks completed',
                value: completed.value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatTile(
                label: 'Tasks added',
                value: added.value,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const SectionLabel('More'),
        Material(
          color: c.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KoshaRadius.card),
            side: BorderSide(color: c.border),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Symbols.dashboard_customize_rounded),
                title: const Text('Dashboard sections'),
                trailing: Icon(Symbols.chevron_right_rounded, color: c.text3),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const CustomizeDashboardScreen(),
                  ),
                ),
              ),
              Divider(height: 1, color: c.hair),
              ListTile(
                leading: const Icon(Symbols.dark_mode_rounded),
                title: const Text('Appearance'),
                trailing: Icon(Symbols.chevron_right_rounded, color: c.text3),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const AppearanceScreen()),
                ),
              ),
              Divider(height: 1, color: c.hair),
              ListTile(
                enabled: false,
                leading: const Icon(Symbols.upload_rounded),
                title: const Text('Export'),
                trailing: Text('Phase 6', style: t.labelSmall),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final int? value;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(KoshaRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value == null ? '—' : '$value', style: t.headlineSmall),
          const SizedBox(height: 4),
          Text(label, style: t.bodySmall),
        ],
      ),
    );
  }
}
