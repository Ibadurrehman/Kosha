import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/kosha_theme.dart';
import 'core/theme/theme_mode_controller.dart';

class KoshaApp extends ConsumerWidget {
  const KoshaApp({super.key});

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
    );
  }
}
