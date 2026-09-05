import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/theme/theme_mode_controller.dart';
import '../../../shared/widgets/widgets.dart';

const List<(ThemeMode, String, IconData)> _modes = [
  (ThemeMode.light, 'Light', Symbols.light_mode_rounded),
  (ThemeMode.dark, 'Dark', Symbols.dark_mode_rounded),
  (ThemeMode.system, 'System', Symbols.contrast_rounded),
];

/// 3 mode rows with a check, a live preview card, and a caption naming what
/// is actually showing right now (relevant when the mode is System).
class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView(
        padding: const EdgeInsets.all(KoshaSpace.screen),
        children: [
          Material(
            color: c.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(KoshaRadius.card),
              side: BorderSide(color: c.border),
            ),
            child: Column(
              children: [
                for (final (index, entry) in _modes.indexed) ...[
                  if (index > 0) Divider(height: 1, color: c.hair),
                  ListTile(
                    leading: Icon(entry.$3, color: c.text2),
                    title: Text(entry.$2),
                    trailing: mode == entry.$1
                        ? Icon(Symbols.check_rounded, color: c.accent)
                        : null,
                    onTap: () => ref.read(themeModeProvider.notifier).set(entry.$1),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: c.sunk,
              borderRadius: BorderRadius.circular(KoshaRadius.card),
              border: Border.all(color: c.border),
            ),
            child: Row(
              children: [
                IconTile(
                  isDark ? Symbols.dark_mode_rounded : Symbols.light_mode_rounded,
                  background: c.accentSoft,
                  color: c.accent,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'This is roughly how Kosha will look.',
                    style: t.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Currently showing ${isDark ? 'dark' : 'light'} mode.',
            style: t.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
