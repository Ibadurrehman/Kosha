import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../shared/widgets/widgets.dart';

/// Placeholder until spaces land in Phase 3.
class SpacesScreen extends StatelessWidget {
  const SpacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spaces')),
      body: const EmptyState(
        icon: Symbols.grid_view_rounded,
        title: 'Spaces',
        body: 'Spaces arrive in Phase 3.',
      ),
    );
  }
}
