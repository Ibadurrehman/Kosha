import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../shared/widgets/widgets.dart';

/// Placeholder until tasks land in Phase 1.
class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: const EmptyState(
        icon: Symbols.check_circle_rounded,
        title: 'Tasks',
        body: 'Tasks arrive in Phase 1.',
      ),
    );
  }
}
