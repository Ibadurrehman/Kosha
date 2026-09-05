import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../shared/widgets/widgets.dart';

/// Placeholder until the calendar lands in Phase 1.
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: const EmptyState(
        icon: Symbols.calendar_month_rounded,
        title: 'Calendar',
        body: 'The calendar arrives in Phase 1.',
      ),
    );
  }
}
