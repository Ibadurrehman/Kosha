import 'package:flutter/material.dart';

/// The prototype's colour tokens (converted from OKLCH to sRGB).
/// Read them through `context.kosha` — never use `Colors.*` in feature code.
@immutable
class KoshaColors extends ThemeExtension<KoshaColors> {
  const KoshaColors({
    required this.bg,
    required this.surface,
    required this.elev,
    required this.sunk,
    required this.border,
    required this.hair,
    required this.text,
    required this.text2,
    required this.text3,
    required this.disabled,
    required this.accent,
    required this.accent2,
    required this.accentSoft,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.error,
    required this.errorSoft,
    required this.info,
    required this.infoSoft,
    required this.shadow,
    required this.lift,
  });

  final Color bg;
  final Color surface;
  final Color elev;
  final Color sunk;
  final Color border;
  final Color hair;
  final Color text;
  final Color text2;
  final Color text3;
  final Color disabled;
  final Color accent;
  final Color accent2;
  final Color accentSoft;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color error;
  final Color errorSoft;
  final Color info;
  final Color infoSoft;
  final List<BoxShadow> shadow;
  final List<BoxShadow> lift;

  /// Toast background is dark in both themes.
  static const Color toastBg = Color(0xFF1C1F25);

  /// Scrim behind sheets and dialogs.
  static const Color scrim = Color(0x700E101C);

  /// Fixed avatar fills; white initials stay readable in both themes.
  static const List<Color> avatarTones = [
    Color(0xFF415DB7),
    Color(0xFF00777E),
    Color(0xFF914D8C),
    Color(0xFF407734),
  ];

  static const KoshaColors light = KoshaColors(
    bg: Color(0xFFF9FAFC),
    surface: Color(0xFFFFFFFF),
    elev: Color(0xFFFFFFFF),
    sunk: Color(0xFFF1F2F5),
    border: Color(0xFFDDE0E4),
    hair: Color(0xFFEBEDF0),
    text: Color(0xFF1B1E25),
    text2: Color(0xFF666A73),
    text3: Color(0xFF90949B),
    disabled: Color(0xFFB8BAC0),
    accent: Color(0xFF415DB7),
    accent2: Color(0xFF667DBC),
    accentSoft: Color(0xFFEBF1FF),
    success: Color(0xFF218456),
    successSoft: Color(0xFFE0F7E9),
    warning: Color(0xFFB5741D),
    warningSoft: Color(0xFFFFF1D8),
    error: Color(0xFFC13835),
    errorSoft: Color(0xFFFFECE9),
    info: Color(0xFF2A77A7),
    infoSoft: Color(0xFFE1F4FF),
    shadow: [
      BoxShadow(color: Color(0x0A141628), offset: Offset(0, 1), blurRadius: 2),
      BoxShadow(color: Color(0x0D141628), offset: Offset(0, 1), blurRadius: 3),
    ],
    lift: [
      BoxShadow(
        color: Color(0x38141628),
        offset: Offset(0, 8),
        blurRadius: 28,
        spreadRadius: -10,
      ),
    ],
  );

  static const KoshaColors dark = KoshaColors(
    bg: Color(0xFF0D0E12),
    surface: Color(0xFF16191D),
    elev: Color(0xFF1F2228),
    sunk: Color(0xFF111317),
    border: Color(0xFF2A2D34),
    hair: Color(0xFF202328),
    text: Color(0xFFF2F3F6),
    text2: Color(0xFFA5A9B1),
    text3: Color(0xFF787C83),
    disabled: Color(0xFF505358),
    accent: Color(0xFF7695ED),
    accent2: Color(0xFF97AEE9),
    accentSoft: Color(0xFF222B45),
    success: Color(0xFF5BC18B),
    successSoft: Color(0xFF122E1F),
    warning: Color(0xFFE1AB50),
    warningSoft: Color(0xFF392A10),
    error: Color(0xFFF1756C),
    errorSoft: Color(0xFF44211E),
    info: Color(0xFF61ACDE),
    infoSoft: Color(0xFF142A39),
    shadow: [
      BoxShadow(color: Color(0x47000000), offset: Offset(0, 1), blurRadius: 2),
    ],
    lift: [
      BoxShadow(
        color: Color(0x99000000),
        offset: Offset(0, 10),
        blurRadius: 30,
        spreadRadius: -10,
      ),
    ],
  );

  @override
  KoshaColors copyWith({
    Color? bg,
    Color? surface,
    Color? elev,
    Color? sunk,
    Color? border,
    Color? hair,
    Color? text,
    Color? text2,
    Color? text3,
    Color? disabled,
    Color? accent,
    Color? accent2,
    Color? accentSoft,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningSoft,
    Color? error,
    Color? errorSoft,
    Color? info,
    Color? infoSoft,
    List<BoxShadow>? shadow,
    List<BoxShadow>? lift,
  }) {
    return KoshaColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      elev: elev ?? this.elev,
      sunk: sunk ?? this.sunk,
      border: border ?? this.border,
      hair: hair ?? this.hair,
      text: text ?? this.text,
      text2: text2 ?? this.text2,
      text3: text3 ?? this.text3,
      disabled: disabled ?? this.disabled,
      accent: accent ?? this.accent,
      accent2: accent2 ?? this.accent2,
      accentSoft: accentSoft ?? this.accentSoft,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      error: error ?? this.error,
      errorSoft: errorSoft ?? this.errorSoft,
      info: info ?? this.info,
      infoSoft: infoSoft ?? this.infoSoft,
      shadow: shadow ?? this.shadow,
      lift: lift ?? this.lift,
    );
  }

  @override
  KoshaColors lerp(KoshaColors? other, double t) {
    if (other is! KoshaColors) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return KoshaColors(
      bg: c(bg, other.bg),
      surface: c(surface, other.surface),
      elev: c(elev, other.elev),
      sunk: c(sunk, other.sunk),
      border: c(border, other.border),
      hair: c(hair, other.hair),
      text: c(text, other.text),
      text2: c(text2, other.text2),
      text3: c(text3, other.text3),
      disabled: c(disabled, other.disabled),
      accent: c(accent, other.accent),
      accent2: c(accent2, other.accent2),
      accentSoft: c(accentSoft, other.accentSoft),
      success: c(success, other.success),
      successSoft: c(successSoft, other.successSoft),
      warning: c(warning, other.warning),
      warningSoft: c(warningSoft, other.warningSoft),
      error: c(error, other.error),
      errorSoft: c(errorSoft, other.errorSoft),
      info: c(info, other.info),
      infoSoft: c(infoSoft, other.infoSoft),
      shadow: t < 0.5 ? shadow : other.shadow,
      lift: t < 0.5 ? lift : other.lift,
    );
  }
}

extension KoshaColorsContext on BuildContext {
  KoshaColors get kosha => Theme.of(this).extension<KoshaColors>()!;
}
