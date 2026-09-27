import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'app.dart';

/// Wires up global error handling and platform services, then runs the app.
///
/// Keep this thin: anything that needs the widget tree or the database belongs
/// in a provider so it can be overridden in tests.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  // `latest_all` rather than `latest`: Android hands the app whatever zone id
  // the device is set to, and that is often a legacy alias the trimmed
  // database does not carry — this emulator reports "Asia/Calcutta", not
  // "Asia/Kolkata". Looking one up and missing leaves every reminder on UTC,
  // which in India is five and a half hours out. See plan §12.5.5.
  tz.initializeTimeZones();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // Phase 6: forward to Sentry when the user has opted in.
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      debugPrint('Uncaught error: $error\n$stack');
    }
    return true;
  };

  runApp(const ProviderScope(child: KoshaApp()));
}
