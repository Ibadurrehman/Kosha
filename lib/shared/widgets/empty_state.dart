import 'package:flutter/material.dart';

import '../../core/theme/kosha_colors.dart';
import 'icon_tile.dart';

/// Icon tile + title + body + optional CTA, centred in its parent.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
    this.tone,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTile(
              icon,
              size: 56,
              color: tone ?? c.accent,
              background: c.accentSoft,
              iconSize: 26,
            ),
            const SizedBox(height: 14),
            Text(title, style: t.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(body, style: t.bodySmall, textAlign: TextAlign.center),
            if (actionLabel != null) ...[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
