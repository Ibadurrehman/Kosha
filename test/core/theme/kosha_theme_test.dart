import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/theme/kosha_colors.dart';
import 'package:kosha/core/theme/kosha_theme.dart';

void main() {
  group('KoshaColors', () {
    test('light and dark palettes carry the prototype accent tokens', () {
      expect(KoshaColors.light.accent, const Color(0xFF415DB7));
      expect(KoshaColors.dark.accent, const Color(0xFF7695ED));
      expect(KoshaColors.light.bg, const Color(0xFFF9FAFC));
      expect(KoshaColors.dark.bg, const Color(0xFF0D0E12));
    });

    test('lerp at 0 and 1 returns the endpoints', () {
      const l = KoshaColors.light;
      const d = KoshaColors.dark;
      expect(l.lerp(d, 0).text, l.text);
      expect(l.lerp(d, 1).text, d.text);
      expect(l.lerp(d, 1).lift, d.lift);
    });

    test('copyWith overrides only the given token', () {
      final c = KoshaColors.light.copyWith(accent: Colors.red);
      expect(c.accent, Colors.red);
      expect(c.bg, KoshaColors.light.bg);
    });
  });

  group('buildKoshaTheme', () {
    test('registers the KoshaColors extension for both brightnesses', () {
      final light = buildKoshaTheme(Brightness.light, useGoogleFonts: false);
      final dark = buildKoshaTheme(Brightness.dark, useGoogleFonts: false);
      expect(light.extension<KoshaColors>(), KoshaColors.light);
      expect(dark.extension<KoshaColors>(), KoshaColors.dark);
      expect(light.scaffoldBackgroundColor, KoshaColors.light.bg);
      expect(dark.scaffoldBackgroundColor, KoshaColors.dark.bg);
    });

    test('type scale matches the prototype headline and label sizes', () {
      final t = buildKoshaTheme(Brightness.light, useGoogleFonts: false).textTheme;
      expect(t.headlineSmall?.fontSize, 26);
      expect(t.headlineSmall?.fontWeight, FontWeight.w700);
      expect(t.labelMedium?.fontSize, 12);
      expect(t.labelMedium?.color, KoshaColors.light.text3);
      expect(t.bodySmall?.color, KoshaColors.light.text2);
    });
  });
}
