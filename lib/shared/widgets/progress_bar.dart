import 'package:flutter/material.dart';

import '../../core/theme/kosha_colors.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, required this.value, this.color, this.height = 6});

  /// 0..1
  final double value;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: value.clamp(0, 1),
        minHeight: height,
        backgroundColor: c.sunk,
        color: color ?? c.accent,
      ),
    );
  }
}
