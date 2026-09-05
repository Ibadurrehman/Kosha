import 'package:flutter/material.dart';

import '../../core/models/priority.dart';
import '../../core/theme/kosha_colors.dart';

export '../../core/models/priority.dart';

/// 8 px dot; hidden for [Priority.none]. Colour is never the only signal —
/// callers also show the label in the meta line.
class PriorityDot extends StatelessWidget {
  const PriorityDot(this.priority, {super.key});

  final Priority priority;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final color = switch (priority) {
      Priority.high => c.error,
      Priority.medium => c.warning,
      Priority.low => c.info,
      Priority.none => null,
    };
    if (color == null) return const SizedBox.shrink();
    return Semantics(
      label: '${priority.label} priority',
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
