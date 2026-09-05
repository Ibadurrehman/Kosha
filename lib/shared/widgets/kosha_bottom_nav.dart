import 'package:flutter/material.dart';

import '../../core/theme/kosha_colors.dart';

class KoshaNavItem {
  const KoshaNavItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

/// Five-tab bar; the active icon is filled and tinted accent.
class KoshaBottomNav extends StatelessWidget {
  const KoshaBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelected,
  });

  final List<KoshaNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 9, 8, 6),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: i == currentIndex,
                    label: items[i].label,
                    child: InkWell(
                      onTap: () => onSelected(i),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              items[i].icon,
                              size: 24,
                              weight: 300,
                              fill: i == currentIndex ? 1 : 0,
                              color: i == currentIndex ? c.accent : c.text3,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              items[i].label,
                              style: t.labelSmall?.copyWith(
                                color: i == currentIndex ? c.accent : c.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
