import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'kosha_colors.dart';
import 'kosha_shapes.dart';
import 'kosha_typography.dart';

/// Tests override this to `false` so no font download is attempted.
final googleFontsEnabledProvider = Provider<bool>((_) => true);

ThemeData buildKoshaTheme(Brightness brightness, {bool useGoogleFonts = true}) {
  final c = brightness == Brightness.dark ? KoshaColors.dark : KoshaColors.light;
  final text = buildKoshaTextTheme(c, useGoogleFonts: useGoogleFonts);

  final scheme = ColorScheme(
    brightness: brightness,
    primary: c.accent,
    onPrimary: Colors.white,
    primaryContainer: c.accentSoft,
    onPrimaryContainer: c.text,
    secondary: c.accent2,
    onSecondary: Colors.white,
    error: c.error,
    onError: Colors.white,
    errorContainer: c.errorSoft,
    onErrorContainer: c.error,
    surface: c.surface,
    onSurface: c.text,
    onSurfaceVariant: c.text2,
    outline: c.border,
    outlineVariant: c.hair,
    surfaceContainerHighest: c.sunk,
    surfaceContainerLow: c.bg,
    shadow: Colors.black,
    scrim: KoshaColors.scrim,
    inverseSurface: KoshaColors.toastBg,
    onInverseSurface: Colors.white,
  );

  RoundedRectangleBorder r(double radius) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));

  OutlineInputBorder inputBorder(Color color, [double width = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(KoshaRadius.input),
        borderSide: BorderSide(color: color, width: width),
      );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.bg,
    canvasColor: c.bg,
    dividerColor: c.hair,
    splashFactory: InkSparkle.splashFactory,
    textTheme: text,
    extensions: [c],
    appBarTheme: AppBarTheme(
      backgroundColor: c.bg,
      foregroundColor: c.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: text.titleMedium,
    ),
    cardTheme: CardThemeData(
      color: c.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: r(KoshaRadius.card).copyWith(side: BorderSide(color: c.border)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: c.accent,
        foregroundColor: Colors.white,
        disabledBackgroundColor: c.sunk,
        disabledForegroundColor: c.disabled,
        minimumSize: const Size.fromHeight(KoshaSize.button),
        shape: r(KoshaRadius.button),
        textStyle: text.labelLarge?.copyWith(fontSize: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: c.text,
        side: BorderSide(color: c.border),
        minimumSize: const Size.fromHeight(KoshaSize.button),
        shape: r(KoshaRadius.button),
        textStyle: text.labelLarge?.copyWith(fontSize: 16),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.accent,
        textStyle: text.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      hintStyle: text.bodyMedium?.copyWith(color: c.text3, fontWeight: FontWeight.w500),
      border: inputBorder(c.border),
      enabledBorder: inputBorder(c.border),
      focusedBorder: inputBorder(c.accent, 1.5),
      errorBorder: inputBorder(c.error),
      focusedErrorBorder: inputBorder(c.error, 1.5),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.elev,
      modalBackgroundColor: c.elev,
      modalBarrierColor: KoshaColors.scrim,
      showDragHandle: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(KoshaRadius.sheet)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.elev,
      shape: r(KoshaRadius.dialog),
      titleTextStyle: text.titleLarge,
      contentTextStyle: text.bodyMedium?.copyWith(color: c.text2),
    ),
    dividerTheme: DividerThemeData(color: c.hair, thickness: 1, space: 1),
    iconTheme: IconThemeData(color: c.text2, size: 22, weight: 300, fill: 0),
    listTileTheme: ListTileThemeData(
      iconColor: c.text2,
      textColor: c.text,
      titleTextStyle: text.titleMedium,
      subtitleTextStyle: text.bodySmall,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: c.accent,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: r(KoshaRadius.fab),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: KoshaColors.toastBg,
      contentTextStyle: text.bodyMedium?.copyWith(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: r(KoshaRadius.toast),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
