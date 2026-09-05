import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../shared/widgets/widgets.dart';
import 'onboarding_actions.dart';

/// Step 1 of 4: no progress bar, just the pitch.
class OnboardingWelcomeScreen extends ConsumerWidget {
  const OnboardingWelcomeScreen({super.key});

  static const _icons = [
    Symbols.task_alt_rounded,
    Symbols.account_balance_wallet_rounded,
    Symbols.folder_shared_rounded,
    Symbols.directions_car_rounded,
    Symbols.checklist_rounded,
    Symbols.flag_rounded,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            KoshaSpace.screen,
            40,
            KoshaSpace.screen,
            24,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [for (final icon in _icons) IconTile(icon, size: 52)],
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Your personal life, organized.',
                      style: t.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tasks, bills, spending, documents and more — one place '
                      'that keeps track so you don’t have to.',
                      style: t.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () => context.go(Routes.onboarding2),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
                child: const Text('Get started'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => unawaited(finishOnboarding(context, ref)),
                child: const Text('Skip'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
