import 'package:flutter/material.dart';

import '../../core/theme/kosha_colors.dart';
import '../../core/theme/kosha_shapes.dart';

/// Filter/selection chip. Selected fills with accent, as in the prototype.
class KoshaChip extends StatelessWidget {
  const KoshaChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.leading,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final fg = selected ? Colors.white : c.text2;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? c.accent : c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KoshaRadius.chip),
          side: BorderSide(color: selected ? c.accent : c.border),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(KoshaRadius.chip),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 6)],
                if (icon != null) ...[
                  Icon(icon, size: 15, color: fg),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: fg, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
