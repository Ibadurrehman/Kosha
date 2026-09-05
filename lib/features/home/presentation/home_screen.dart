import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../shared/widgets/widgets.dart';

/// Placeholder until the dashboard lands in Phase 1.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const EmptyState(
        icon: Symbols.home_rounded,
        title: 'Home',
        body: 'The dashboard arrives in Phase 1.',
      ),
    );
  }
}
