import 'package:flutter/material.dart';

import '../../core/theme/kosha_colors.dart';

/// Rounded square with a centred icon, used as a row leading element.
class IconTile extends StatelessWidget {
  const IconTile(
    this.icon, {
    super.key,
    this.size = 38,
    this.color,
    this.background,
    this.iconSize,
  });

  final IconData icon;
  final double size;
  final Color? color;
  final Color? background;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background ?? c.sunk,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(icon, size: iconSize ?? size * 0.5, color: color ?? c.text2),
    );
  }
}
