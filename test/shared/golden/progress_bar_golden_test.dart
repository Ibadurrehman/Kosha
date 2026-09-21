import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:kosha/shared/widgets/progress_bar.dart';

import 'golden_helpers.dart';

void main() {
  koshaGoldenTest(
    'ProgressBar',
    fileName: 'progress_bar',
    scenarios: [
      GoldenTestScenario(
        name: 'empty',
        child: const SizedBox(width: 220, child: ProgressBar(value: 0)),
      ),
      GoldenTestScenario(
        name: 'part way',
        child: const SizedBox(width: 220, child: ProgressBar(value: 0.45)),
      ),
      GoldenTestScenario(
        name: 'full',
        child: const SizedBox(width: 220, child: ProgressBar(value: 1)),
      ),
      GoldenTestScenario(
        name: 'over one is clamped',
        child: const SizedBox(width: 220, child: ProgressBar(value: 1.8)),
      ),
      GoldenTestScenario(
        name: 'thin',
        child: const SizedBox(
          width: 220,
          child: ProgressBar(value: 0.6, height: 3),
        ),
      ),
    ],
  );
}
