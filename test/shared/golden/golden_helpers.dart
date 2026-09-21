import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:kosha/core/theme/kosha_theme.dart';

/// One golden per shared component, rendered in both themes.
///
/// Section 15 asks for goldens "light + dark" for every shared component, and
/// Phase 0's exit criteria make them a gate. Each call produces two files —
/// `<name>_light` and `<name>_dark` — so a change that only breaks dark mode
/// (the easiest thing to miss by eye) fails on its own.
///
/// Google Fonts is switched off: it fetches over the network at runtime, which
/// a golden must never depend on. `buildKoshaTheme(useGoogleFonts: false)`
/// falls back to the bundled family, so the goldens exercise the same theme
/// the app ships with offline.
void koshaGoldenTest(
  String description, {
  required String fileName,
  required List<GoldenTestScenario> scenarios,
  Size? constraints,
  bool animates = false,
}) {
  for (final brightness in Brightness.values) {
    final suffix = brightness == Brightness.light ? 'light' : 'dark';
    // alchemist 0.14 takes the theme from the ambient config rather than a
    // per-test argument, so each brightness runs inside its own scope.
    AlchemistConfig.runWithConfig(
      config: AlchemistConfig.current().copyWith(
        theme: buildKoshaTheme(brightness, useGoogleFonts: false),
      ),
      run: () => goldenTest(
        '$description renders in $suffix mode',
        fileName: '${fileName}_$suffix',
        // A component that animates forever (the skeleton shimmer) never
        // settles, so it is captured at a fixed frame instead.
        pumpBeforeTest: animates
            ? (tester) async => tester.pump(const Duration(milliseconds: 250))
            : onlyPumpAndSettle,
        builder: () => GoldenTestGroup(
          columns: 1,
          scenarioConstraints: constraints == null
              ? null
              : BoxConstraints.tight(constraints),
          children: scenarios,
        ),
      ),
    );
  }
}
