import 'package:flutter/material.dart';

import '../../core/theme/kosha_colors.dart';
import '../../core/theme/kosha_shapes.dart';

/// Shimmering placeholder rows shown while a list loads.
class SkeletonList extends StatefulWidget {
  const SkeletonList({super.key, this.rows = 3});

  final int rows;

  @override
  State<SkeletonList> createState() => _SkeletonListState();
}

class _SkeletonListState extends State<SkeletonList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final reduce = MediaQuery.disableAnimationsOf(context);
    final opacity = reduce
        ? const AlwaysStoppedAnimation<double>(0.65)
        : Tween<double>(begin: 0.45, end: 0.85).animate(_ctrl);
    return FadeTransition(
      opacity: opacity,
      child: Column(
        children: [
          for (var i = 0; i < widget.rows; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: c.surface,
                border: Border.all(color: c.border),
                borderRadius: BorderRadius.circular(KoshaRadius.row),
              ),
              child: Row(
                children: [
                  _Block(width: 38, height: 38, radius: 11, color: c.sunk),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Block(width: 160, height: 12, radius: 6, color: c.sunk),
                        const SizedBox(height: 8),
                        _Block(width: 100, height: 10, radius: 5, color: c.sunk),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({
    required this.width,
    required this.height,
    required this.radius,
    required this.color,
  });

  final double width;
  final double height;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}
