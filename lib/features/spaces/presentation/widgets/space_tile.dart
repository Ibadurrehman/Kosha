import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/theme/kosha_shapes.dart';
import '../../domain/entities/space.dart';
import '../../domain/entities/space_summary.dart';
import '../space_icons.dart';
import '../space_labels.dart';

/// One tile in the Spaces grid: icon, name, and a live sub-line.
class SpaceTile extends StatelessWidget {
  const SpaceTile({
    super.key,
    required this.space,
    required this.summary,
    required this.onTap,
    this.onLongPress,
  });

  final Space space;
  final SpaceSummary summary;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: '${space.name}. ${spaceSubLine(summary)}',
      // The children already say all of this; without excluding them a
      // screen reader reads the name, then the name again inside the tile.
      excludeSemantics: true,
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(KoshaRadius.tile),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(KoshaRadius.tile),
          child: Container(
            padding: const EdgeInsets.all(KoshaSpace.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(KoshaRadius.tile),
              border: Border.all(color: c.hair),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c.accentSoft,
                    borderRadius: BorderRadius.circular(KoshaRadius.chip),
                  ),
                  child: Icon(
                    spaceIcon(space.iconKey),
                    size: 22,
                    color: c.accent,
                  ),
                ),
                const SizedBox(height: KoshaSpace.md),
                Text(
                  space.name,
                  style: t.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  spaceSubLine(summary),
                  style: t.bodySmall?.copyWith(color: c.text3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The "New space" tile that closes the grid.
class NewSpaceTile extends StatelessWidget {
  const NewSpaceTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: 'New space',
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(KoshaRadius.tile),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(KoshaRadius.tile),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(KoshaRadius.tile),
              border: Border.all(color: c.border),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Symbols.create_new_folder_rounded,
                      size: 24, color: c.text3),
                  const SizedBox(height: KoshaSpace.sm),
                  Text(
                    'New space',
                    style: t.titleSmall?.copyWith(color: c.text2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
