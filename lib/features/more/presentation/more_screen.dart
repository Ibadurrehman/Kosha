import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/config/app_config.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../shared/widgets/widgets.dart';
import '../../onboarding/domain/entities/profile.dart';
import '../../onboarding/presentation/controllers/onboarding_providers.dart';

/// Profile row, then the App group (Settings, and Design states in debug
/// builds). Your spaces / Capture (Notes, Ideas, Goals) arrive with Phases
/// 3 and 4.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final profile = ref.watch(profileProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (profile != null) _ProfileRow(profile: profile),
          const SizedBox(height: 24),
          const SectionLabel('App'),
          Material(
            color: c.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: c.border),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const IconTile(Symbols.settings_rounded),
                  title: const Text('Settings'),
                  trailing: Icon(Symbols.chevron_right_rounded, color: c.text3),
                  onTap: () => context.go(Routes.settings),
                ),
                if (AppConfig.showDebugTools) ...[
                  Divider(height: 1, color: c.hair),
                  ListTile(
                    leading: const IconTile(Symbols.layers_rounded),
                    title: const Text('Design states'),
                    subtitle: const Text('Every shared component in every state'),
                    trailing: Icon(Symbols.chevron_right_rounded, color: c.text3),
                    onTap: () => context.go(Routes.statesGallery),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          const EmptyState(
            icon: Symbols.more_horiz_rounded,
            title: 'More on the way',
            body: 'Your spaces arrives in Phase 3; Notes, Ideas and Goals in '
                'Phase 4.',
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: c.border),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: KoshaColors.avatarTones.first,
          child: Text(
            profile.avatarInitials,
            style: t.titleSmall?.copyWith(color: Colors.white),
          ),
        ),
        title: Text(profile.name),
        subtitle: Text(profile.email ?? 'Tap to view your profile'),
        trailing: Icon(Symbols.chevron_right_rounded, color: c.text3),
        onTap: () => context.go(Routes.profile),
      ),
    );
  }
}
