import 'package:flutter/material.dart';

import '../../core/theme/kosha_colors.dart';
import '../../core/theme/kosha_shapes.dart';

/// Sunk track with a raised selected segment. Scrolls horizontally when the
/// labels do not fit.
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final selectedBg = dark ? const Color(0xFF2E3238) : c.surface;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: c.sunk,
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(KoshaRadius.tabTrack),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < labels.length; i++)
              Semantics(
                button: true,
                selected: i == selectedIndex,
                child: Material(
                  color: i == selectedIndex ? selectedBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(KoshaRadius.tab),
                  elevation: i == selectedIndex && !dark ? 1 : 0,
                  shadowColor: Colors.black26,
                  child: InkWell(
                    onTap: () => onChanged(i),
                    borderRadius: BorderRadius.circular(KoshaRadius.tab),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                      child: Text(
                        labels[i],
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: i == selectedIndex ? c.text : c.text2,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
