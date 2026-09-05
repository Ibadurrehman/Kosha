import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../shared/widgets/kosha_bottom_nav.dart';

/// Scaffold around the five tab branches.
class KoshaShell extends StatelessWidget {
  const KoshaShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const items = [
    KoshaNavItem(label: 'Home', icon: Symbols.home_rounded),
    KoshaNavItem(label: 'Tasks', icon: Symbols.check_circle_rounded),
    KoshaNavItem(label: 'Spaces', icon: Symbols.grid_view_rounded),
    KoshaNavItem(label: 'Calendar', icon: Symbols.calendar_month_rounded),
    KoshaNavItem(label: 'More', icon: Symbols.more_horiz_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: KoshaBottomNav(
        items: items,
        currentIndex: navigationShell.currentIndex,
        onSelected: (i) => navigationShell.goBranch(
          i,
          // Re-tapping the active tab pops that branch to its root.
          initialLocation: i == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
