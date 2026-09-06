import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../shared/state/toast_controller.dart';
import '../../tasks/presentation/widgets/new_task_sheet.dart';
import 'onboarding_actions.dart';
import 'widgets/onboarding_progress.dart';

/// Step 4 of 4. Only "A task" does something real today — Finance and
/// Documents don't exist until later phases, so those rows toast the same
/// "arriving later" message the rest of the still-missing screens use.
class OnboardingFirstItemScreen extends ConsumerWidget {
  const OnboardingFirstItemScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            KoshaSpace.screen,
            0,
            KoshaSpace.screen,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OnboardingProgress(step: 4),
              const SizedBox(height: 18),
              Text('Add your first thing', style: t.headlineSmall),
              const SizedBox(height: 6),
              Text(
                'Start with whatever is on your mind right now.',
                style: t.bodySmall,
              ),
              const SizedBox(height: 20),
              _OptionRow(
                icon: Symbols.task_alt_rounded,
                label: 'A task',
                onTap: () => unawaited(_addTask(context, ref)),
              ),
              _OptionRow(
                icon: Symbols.account_balance_wallet_rounded,
                label: 'An expense',
                onTap: () => _notYet(ref),
              ),
              _OptionRow(
                icon: Symbols.folder_shared_rounded,
                label: 'A document',
                onTap: () => _notYet(ref),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () => unawaited(finishOnboarding(context, ref)),
                  child: const Text('Skip'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _notYet(WidgetRef ref) => ref
      .read(toastControllerProvider.notifier)
      .show('Arriving in a later phase');

  /// Opens the real New task sheet; either way it's dismissed (created or
  /// cancelled), onboarding is done and the app lands on Home, matching the
  /// "≤ 4 taps to Home" acceptance criterion.
  Future<void> _addTask(BuildContext context, WidgetRef ref) async {
    await showNewTaskSheet(context);
    if (context.mounted) await finishOnboarding(context, ref);
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KoshaRadius.row),
          side: BorderSide(color: c.border),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(KoshaRadius.row),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
            child: Row(
              children: [
                Icon(icon, size: 21, color: c.text2),
                const SizedBox(width: 14),
                Expanded(child: Text(label, style: t.titleSmall)),
                Icon(Symbols.chevron_right_rounded, size: 20, color: c.text3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
