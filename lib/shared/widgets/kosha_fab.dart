import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/kosha_colors.dart';
import '../../core/theme/kosha_shapes.dart';

/// The "+" that opens the quick-add sheet.
class KoshaFab extends StatelessWidget {
  const KoshaFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Semantics(
      button: true,
      label: 'Add something',
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(KoshaRadius.fab),
          boxShadow: [
            BoxShadow(
              color: c.accent.withValues(alpha: 0.7),
              offset: const Offset(0, 10),
              blurRadius: 24,
              spreadRadius: -8,
            ),
          ],
        ),
        child: SizedBox(
          width: KoshaSize.fab,
          height: KoshaSize.fab,
          child: FloatingActionButton(
            onPressed: onPressed,
            heroTag: null,
            child: const Icon(Symbols.add_rounded, size: 28, weight: 400),
          ),
        ),
      ),
    );
  }
}
