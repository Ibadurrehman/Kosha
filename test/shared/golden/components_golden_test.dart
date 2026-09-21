import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:kosha/core/models/priority.dart';
import 'package:kosha/shared/widgets/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'golden_helpers.dart';

/// Goldens for the shared component library (section 7.4), light and dark —
/// Phase 0's exit criterion. `progress_bar_golden_test.dart` covers the one
/// remaining component on its own.
void main() {
  koshaGoldenTest(
    'IconTile',
    fileName: 'icon_tile',
    scenarios: [
      GoldenTestScenario(
        name: 'default',
        child: const IconTile(Symbols.receipt_long_rounded),
      ),
      GoldenTestScenario(
        name: 'large',
        child: const IconTile(Symbols.savings_rounded, size: 56, iconSize: 26),
      ),
      GoldenTestScenario(
        name: 'tinted',
        child: Builder(
          builder: (context) => IconTile(
            Symbols.check_circle_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    ],
  );

  koshaGoldenTest(
    'StatusPill',
    fileName: 'status_pill',
    scenarios: [
      for (final status in KoshaStatus.values)
        GoldenTestScenario(name: status.name, child: StatusPill(status)),
      GoldenTestScenario(
        name: 'with an icon and custom label',
        child: const StatusPill(
          KoshaStatus.overdue,
          label: 'Overdue by 3 days',
          icon: Symbols.schedule_rounded,
        ),
      ),
    ],
  );

  koshaGoldenTest(
    'KoshaChip',
    fileName: 'kosha_chip',
    scenarios: [
      GoldenTestScenario(
        name: 'unselected',
        child: KoshaChip(label: 'Groceries', selected: false, onTap: () {}),
      ),
      GoldenTestScenario(
        name: 'selected',
        child: KoshaChip(label: 'Groceries', selected: true, onTap: () {}),
      ),
      GoldenTestScenario(
        name: 'with an icon',
        child: KoshaChip(
          label: 'Transport',
          icon: Symbols.train_rounded,
          selected: false,
          onTap: () {},
        ),
      ),
    ],
  );

  koshaGoldenTest(
    'KoshaToggle',
    fileName: 'kosha_toggle',
    scenarios: [
      GoldenTestScenario(
        name: 'off',
        child: KoshaToggle(value: false, onChanged: (_) {}),
      ),
      GoldenTestScenario(
        name: 'on',
        child: KoshaToggle(value: true, onChanged: (_) {}),
      ),
    ],
  );

  koshaGoldenTest(
    'PriorityDot',
    fileName: 'priority_dot',
    scenarios: [
      for (final priority in Priority.values)
        GoldenTestScenario(name: priority.name, child: PriorityDot(priority)),
    ],
  );

  koshaGoldenTest(
    'SectionLabel',
    fileName: 'section_label',
    scenarios: [
      GoldenTestScenario(
        name: 'plain',
        child: const SizedBox(width: 260, child: SectionLabel('Needs attention')),
      ),
      GoldenTestScenario(
        name: 'with a trailing action',
        child: SizedBox(
          width: 260,
          child: SectionLabel(
            'Recent transactions',
            trailing: TextButton(onPressed: () {}, child: const Text('See all')),
          ),
        ),
      ),
    ],
  );

  koshaGoldenTest(
    'SegmentedTabs',
    fileName: 'segmented_tabs',
    scenarios: [
      GoldenTestScenario(
        name: 'first selected',
        child: SizedBox(
          width: 320,
          child: SegmentedTabs(
            labels: const ['All', 'Due Soon', 'Overdue'],
            selectedIndex: 0,
            onChanged: (_) {},
          ),
        ),
      ),
      GoldenTestScenario(
        name: 'middle selected',
        child: SizedBox(
          width: 320,
          child: SegmentedTabs(
            labels: const ['All', 'Due Soon', 'Overdue'],
            selectedIndex: 1,
            onChanged: (_) {},
          ),
        ),
      ),
    ],
  );

  koshaGoldenTest(
    'EmptyState',
    fileName: 'empty_state',
    constraints: const Size(320, 300),
    scenarios: [
      GoldenTestScenario(
        name: 'without an action',
        child: const EmptyState(
          icon: Symbols.receipt_long_rounded,
          title: 'No bills yet',
          body: 'Add the ones you pay every month.',
        ),
      ),
      GoldenTestScenario(
        name: 'with an action',
        child: EmptyState(
          icon: Symbols.task_alt_rounded,
          title: 'Nothing planned for today',
          body: "You're all caught up.",
          actionLabel: 'Add task',
          onAction: () {},
        ),
      ),
    ],
  );

  koshaGoldenTest(
    'KoshaFab',
    fileName: 'kosha_fab',
    scenarios: [
      GoldenTestScenario(name: 'default', child: KoshaFab(onPressed: () {})),
    ],
  );

  koshaGoldenTest(
    'SkeletonList',
    fileName: 'skeleton_list',
    constraints: const Size(320, 260),
    animates: true,
    scenarios: [
      GoldenTestScenario(
        name: 'three rows',
        child: const SkeletonList(),
      ),
      GoldenTestScenario(
        name: 'one row',
        child: const SkeletonList(rows: 1),
      ),
    ],
  );

  koshaGoldenTest(
    'KoshaBottomNav',
    fileName: 'kosha_bottom_nav',
    constraints: const Size(380, 90),
    scenarios: [
      GoldenTestScenario(
        name: 'home selected',
        child: KoshaBottomNav(
          items: const [
            KoshaNavItem(label: 'Home', icon: Symbols.home_rounded),
            KoshaNavItem(label: 'Tasks', icon: Symbols.check_circle_rounded),
            KoshaNavItem(label: 'Spaces', icon: Symbols.grid_view_rounded),
            KoshaNavItem(label: 'Calendar', icon: Symbols.calendar_month_rounded),
            KoshaNavItem(label: 'More', icon: Symbols.more_horiz_rounded),
          ],
          currentIndex: 0,
          onSelected: (_) {},
        ),
      ),
    ],
  );

  koshaGoldenTest(
    'AmountKeypad',
    fileName: 'amount_keypad',
    constraints: const Size(320, 300),
    scenarios: [
      GoldenTestScenario(
        name: 'twelve keys',
        child: AmountKeypad(value: '1850', onChanged: (_) {}),
      ),
    ],
  );
}
