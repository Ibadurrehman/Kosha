import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app.dart';

/// Wires up global error handling and platform services, then runs the app.
///
/// Keep this thin: anything that needs the widget tree or the database belongs
/// in a provider so it can be overridden in tests.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
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
