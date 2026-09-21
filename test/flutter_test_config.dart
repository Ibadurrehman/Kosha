import 'dart:async';

import 'package:alchemist/alchemist.dart';

/// Applies to every test under `test/`.
///
/// Alchemist can write two kinds of golden: a *platform* golden that captures
/// the host's real text rendering, and a *CI* golden that forces a bundled
/// font and switches shadows off so the same bytes come out on any machine.
/// Only the CI kind is enabled here — the platform kind is generated on
/// whatever developer machine happens to run it and then fails for everyone
/// else, which is exactly the flakiness that makes teams give up on goldens.
/// The trade-off is that CI goldens render text as uniform blocks, so they
/// catch layout, size and colour changes rather than typography.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await AlchemistConfig.runWithConfig(
    config: const AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(enabled: false),
    ),
    run: testMain,
  );
}
