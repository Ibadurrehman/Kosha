import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/services/notifications/reminder_scheduler.dart';
import 'core/theme/kosha_theme.dart';
import 'core/theme/theme_mode_controller.dart';
import 'core/utils/clock.dart';
import 'features/calendar/data/event_repository_impl.dart';
import 'features/notifications/data/notification_repository_impl.dart';
import 'features/onboarding/presentation/controllers/onboarding_providers.dart';
import 'features/tasks/data/task_repository_impl.dart';
import 'shared/widgets/toast_host.dart';

class KoshaApp extends ConsumerStatefulWidget {
  const KoshaApp({super.key});

  @override
  ConsumerState<KoshaApp> createState() => _KoshaAppState();
}

class _KoshaAppState extends ConsumerState<KoshaApp> {
  StreamSubscription<String>? _notificationTaps;

  @override
  void initState() {
    super.initState();
    // After the first frame so the database is never opened during a build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_resyncReminders());
      unawaited(_reconcileNotifications());
    });
    _notificationTaps = ref
        .read(reminderSchedulerProvider)
        .notificationTaps
        .listen((route) => ref.read(appRouterProvider).go(route));
  }

  @override
  void dispose() {
    unawaited(_notificationTaps?.cancel());
    super.dispose();
  }

  /// Re-registers reminders on launch. Best-effort: a device that refuses to
  /// schedule notifications, or a platform with no notification plugin at all,
  /// must not stop the app from starting, so the failure is logged rather than
  /// left to surface as an uncaught async error.
  Future<void> _resyncReminders() async {
    try {
      await ref.read(taskRepositoryProvider).resyncReminders();
      await ref.read(eventRepositoryProvider).resyncReminders();
    } on Object catch (error, stack) {
      debugPrint('Kosha: could not re-register reminders ($error)');
      debugPrintStack(stackTrace: stack);
    }
  }

  /// Reconciles the notification inbox: a reminder can fire while the app is
  /// killed, so this is how the inbox learns about it, on every launch.
  /// Best-effort for the same reason as [_resyncReminders].
  Future<void> _reconcileNotifications() async {
    try {
      final now = ref.read(clockProvider).now();
      await ref.read(notificationRepositoryProvider).reconcile(now: now);
    } on Object catch (error, stack) {
      debugPrint('Kosha: could not reconcile notifications ($error)');
      debugPrintStack(stackTrace: stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Waits for the profile's first value before ever building the router:
    // the router's own redirect only reacts to *changes* after that (see
    // app_router.dart), so without this gate a returning user could flash the
    // onboarding screen for one frame while the first database read is still
    // in flight.
    final ready = ref.watch(profileReadyProvider);
    return ready.when(
      data: (_) => const _RouterApp(),
      loading: () => const _Splash(),
      error: (error, stack) => const _Splash(),
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
}

class _RouterApp extends ConsumerWidget {
  const _RouterApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
