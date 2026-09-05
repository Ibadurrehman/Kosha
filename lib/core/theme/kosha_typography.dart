import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'kosha_colors.dart';

/// Plus Jakarta Sans scale from section 7.2 of the plan.
TextTheme buildKoshaTextTheme(KoshaColors c, {required bool useGoogleFonts}) {
  final base = ThemeData(brightness: Brightness.light).textTheme;
  final family = useGoogleFonts ? GoogleFonts.plusJakartaSansTextTheme(base) : base;

  TextStyle s(
    TextStyle? from, {
    required double size,
    required FontWeight weight,
    double height = 1.2,
    double spacing = 0,
    Color? color,
  }) =>
      (from ?? const TextStyle()).copyWith(
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: spacing,
        color: color ?? c.text,
      );

  return family.copyWith(
    displaySmall: s(family.displaySmall, size: 40, weight: FontWeight.w800, height: 1),
    headlineMedium: s(family.headlineMedium, size: 30, weight: FontWeight.w800, height: 1.05, spacing: -0.66),
    headlineSmall: s(family.headlineSmall, size: 26, weight: FontWeight.w700, height: 1.15, spacing: -0.62),
    titleLarge: s(family.titleLarge, size: 18, weight: FontWeight.w700, spacing: -0.2),
    titleMedium: s(family.titleMedium, size: 15, weight: FontWeight.w600, height: 1.3),
    titleSmall: s(family.titleSmall, size: 14, weight: FontWeight.w600, height: 1.3),
    bodyLarge: s(family.bodyLarge, size: 16, weight: FontWeight.w400, height: 1.5),
    bodyMedium: s(family.bodyMedium, size: 14.5, weight: FontWeight.w400, height: 1.5),
    bodySmall: s(family.bodySmall, size: 12.5, weight: FontWeight.w500, height: 1.4, color: c.text2),
    labelLarge: s(family.labelLarge, size: 13, weight: FontWeight.w600, height: 1),
    labelMedium: s(family.labelMedium, size: 12, weight: FontWeight.w600, height: 1, spacing: 0.96, color: c.text3),
    labelSmall: s(family.labelSmall, size: 11, weight: FontWeight.w600, height: 1, color: c.text3),
  );
}
