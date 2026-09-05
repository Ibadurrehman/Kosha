import 'package:flutter/material.dart';

import '../../../../shared/widgets/widgets.dart';

/// "n of 4" bar shown on onboarding steps 2–4.
class OnboardingProgress extends StatelessWidget {
  const OnboardingProgress({super.key, required this.step});

  /// 2, 3 or 4 — step 1 (Welcome) shows no progress bar.
  final int step;

  static const int totalSteps = 4;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$step of $totalSteps', style: t.labelMedium),
        const SizedBox(height: 8),
        ProgressBar(value: step / totalSteps),
      ],
    );
  }
}
