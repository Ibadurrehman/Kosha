import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/kosha_theme.dart';
import 'core/theme/theme_mode_controller.dart';
import 'features/tasks/data/task_repository_impl.dart';
import 'shared/widgets/toast_host.dart';

class KoshaApp extends ConsumerStatefulWidget {
  const KoshaApp({super.key});

  @override
  ConsumerState<KoshaApp> createState() => _KoshaAppState();
}

class _KoshaAppState extends ConsumerState<KoshaApp> {
  @override
  void initState() {
    super.initState();
    // After the first frame so the database is never opened during a build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_resyncReminders());
    });
  }

  /// Re-registers reminders on launch. Best-effort: a device that refuses to
  /// schedule notifications, or a platform with no notification plugin at all,
  /// must not stop the app from starting, so the failure is logged rather than
  /// left to surface as an uncaught async error.
  Future<void> _resyncReminders() async {
    try {
      await ref.read(taskRepositoryProvider).resyncReminders();
    } on Object catch (error, stack) {
      debugPrint('Kosha: could not re-register reminders ($error)');
      debugPrintStack(stackTrace: stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final useGoogleFonts = ref.watch(googleFontsEnabledProvider);
    return MaterialApp.router(
      title: 'Kosha',
      debugShowCheckedModeBanner: false,
      theme: buildKoshaTheme(Brightness.light, useGoogleFonts: useGoogleFonts),
      darkTheme: buildKoshaTheme(Brightness.dark, useGoogleFonts: useGoogleFonts),
      themeMode: themeMode,
      routerConfig: router,
      // Above the navigator so a toast survives route changes and covers sheets.
      builder: (context, child) =>
          ToastHost(child: child ?? const SizedBox.shrink()),
    );
  }
}
