import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/config/app_config.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../shared/widgets/widgets.dart';

/// Placeholder "More" tab. In dev builds it links to the States gallery.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (AppConfig.showDebugTools) ...[
            const SectionLabel('Developer'),
            Material(
              color: c.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: c.border),
              ),
              child: ListTile(
                leading: const IconTile(Symbols.layers_rounded),
                title: const Text('Design states'),
                subtitle: const Text('Every shared component in every state'),
                trailing: Icon(Symbols.chevron_right_rounded, color: c.text3),
                onTap: () => context.go(Routes.statesGallery),
              ),
            ),
          ],
          const SizedBox(height: 24),
          const EmptyState(
            icon: Symbols.more_horiz_rounded,
            title: 'More',
            body: 'Notes, Ideas, Goals, Profile and Settings arrive in Phases 1 and 4.',
          ),
        ],
      ),
    );
  }
}
