import 'package:flutter/foundation.dart';

enum Flavor { dev, prod }

/// Build-time configuration. Values come from `--dart-define-from-file`
/// (see `config/dev.json` and `config/prod.json`).
abstract final class AppConfig {
  static const Flavor flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev') == 'prod'
          ? Flavor.prod
          : Flavor.dev;

  /// Load the demo fixture (Appendix B of the plan) into an empty database.
  static const bool seedDemoData = bool.fromEnvironment('SEED_DEMO_DATA');

  /// Read by the crash reporter that Phase 6 adds. The `sentry_flutter`
  /// package is not a dependency yet: its Gradle build pins Kotlin language
  /// version 1.6, which the bundled Kotlin compiler rejects.
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');

  static bool get isDev => flavor == Flavor.dev;

  /// Debug-only surfaces such as the States gallery.
  static bool get showDebugTools => isDev || kDebugMode;
}
