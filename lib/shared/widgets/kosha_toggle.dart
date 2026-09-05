import 'package:flutter/material.dart';

import '../../core/theme/kosha_colors.dart';
import '../../core/theme/kosha_shapes.dart';

/// 46×28 switch matching the prototype; the hit area is padded to 44 px.
class KoshaToggle extends StatelessWidget {
  const KoshaToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Semantics(
      toggled: value,
      label: semanticLabel,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: KoshaSize.toggleW,
            height: KoshaSize.toggleH,
            padding: const EdgeInsets.symmetric(horizontal: 3),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            decoration: BoxDecoration(
              color: value ? c.accent : c.sunk,
              border: Border.all(color: value ? c.accent : c.border),
              borderRadius: BorderRadius.circular(KoshaSize.toggleH / 2),
            ),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: value ? Colors.white : c.surface,
                shape: BoxShape.circle,
                boxShadow: c.shadow,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
