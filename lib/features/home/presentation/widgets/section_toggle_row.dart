import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../shared/widgets/kosha_toggle.dart';
import '../../domain/entities/dashboard_section.dart';
import '../controllers/home_providers.dart';

IconData _iconFor(HomeSectionKey key) => switch (key) {
      HomeSectionKey.attention => Symbols.notifications_active_rounded,
      HomeSectionKey.today => Symbols.today_rounded,
      HomeSectionKey.upcoming => Symbols.event_repeat_rounded,
      HomeSectionKey.quickAccess => Symbols.dashboard_customize_rounded,
      HomeSectionKey.recent => Symbols.schedule_rounded,
    };

/// One row: icon, name, hint, toggle. Shared by onboarding's "Choose
/// dashboard" step and Settings' Customize dashboard screen.
class SectionToggleRow extends StatelessWidget {
  const SectionToggleRow({
    super.key,
    required this.section,
    required this.onChanged,
    this.dragHandle,
  });

  final DashboardSection section;
  final ValueChanged<bool> onChanged;

  /// A drag handle on the trailing edge, for the reorderable Customize
  /// dashboard screen; omitted on the plain onboarding step.
  final Widget? dragHandle;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(_iconFor(section.key), size: 20, color: c.text2),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(section.key.label, style: t.titleSmall),
                const SizedBox(height: 2),
                Text(dashboardSectionHint(section.key), style: t.bodySmall),
              ],
            ),
          ),
          KoshaToggle(
            value: section.enabled,
            onChanged: onChanged,
            semanticLabel: '${section.key.label} on Home',
          ),
          ?dragHandle,
        ],
      ),
    );
  }
}
