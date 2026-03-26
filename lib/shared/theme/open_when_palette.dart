import 'package:flutter/material.dart';

/// Brand colors resolved per theme (ThemeExtension on ThemeData).
class OpenWhenPalette extends ThemeExtension<OpenWhenPalette> {
  final Brightness brightness;
  final Color bg;
  final Color card;
  final Color white;
  final Color ink;
  final Color inkSoft;
  final Color inkFaint;
  final Color accent;
  final Color accentWarm;
  final Color accentDark;
  final Color gold;
  final Color goldLight;
  final Color border;
  final Color divider;
  final Color cardBorder;
  final List<Color> headerGradient;
  final Color elevatedButtonBg;
  final Color elevatedButtonFg;
  final Color fabBg;
  final Color fabFg;
  final Color bottomNavBg;
  final Color bottomNavSelected;
  final Color bottomNavUnselected;
  final Color shadow;

  const OpenWhenPalette({
    required this.brightness,
    required this.bg,
    required this.card,
    required this.white,
    required this.ink,
    required this.inkSoft,
    required this.inkFaint,
    required this.accent,
    required this.accentWarm,
    required this.accentDark,
    required this.gold,
    required this.goldLight,
    required this.border,
    required this.divider,
    required this.cardBorder,
    required this.headerGradient,
    required this.elevatedButtonBg,
    required this.elevatedButtonFg,
    required this.fabBg,
    required this.fabFg,
    required this.bottomNavBg,
    required this.bottomNavSelected,
    required this.bottomNavUnselected,
    required this.shadow,
  });

  static const List<Color> _classicHeader = [
    Color(0xFF1A1714),
    Color(0xFF2C1810),
    Color(0xFF1A1714),
  ];

  factory OpenWhenPalette.classic() {
    return const OpenWhenPalette(
      brightness: Brightness.light,
      bg: Color(0xFFF7F4F0),
      card: Color(0xFFFFFFFF),
      white: Color(0xFFFFFFFF),
      ink: Color(0xFF1A1714),
      inkSoft: Color(0xFF6B6560),
      inkFaint: Color(0xFFC4BFB9),
      accent: Color(0xFFC0392B),
      accentWarm: Color(0xFFF0EAE4),
      accentDark: Color(0xFFA93226),
      gold: Color(0xFFC9A84C),
      goldLight: Color(0xFFF5EDD6),
      border: Color(0xFFEDE8E3),
      divider: Color(0xFFF5F0EB),
      cardBorder: Color(0xFFEDE8E3),
      headerGradient: _classicHeader,
      elevatedButtonBg: Color(0xFF1A1714),
      elevatedButtonFg: Color(0xFFFFFFFF),
      fabBg: Color(0xFFC0392B),
      fabFg: Color(0xFFFFFFFF),
      bottomNavBg: Color(0xFFFFFFFF),
      bottomNavSelected: Color(0xFF1A1714),
      bottomNavUnselected: Color(0xFFC4BFB9),
      shadow: Color(0x331A1714),
    );
  }

  factory OpenWhenPalette.dark() {
    return const OpenWhenPalette(
      brightness: Brightness.dark,
      bg: Color(0xFF1A1714),
      card: Color(0xFF252018),
      white: Color(0xFFF5F0EB),
      ink: Color(0xFFF5F0EB),
      inkSoft: Color(0xFFB8B0A8),
      inkFaint: Color(0xFF7A726A),
      accent: Color(0xFFE74C3C),
      accentWarm: Color(0xFF2C2420),
      accentDark: Color(0xFFC0392B),
      gold: Color(0xFFD4AF37),
      goldLight: Color(0xFF3D3528),
      border: Color(0xFF2C2620),
      divider: Color(0xFF252018),
      cardBorder: Color(0xFF2C2620),
      headerGradient: [
        Color(0xFF0D0B09),
        Color(0xFF1A1410),
        Color(0xFF0D0B09),
      ],
      elevatedButtonBg: Color(0xFFE74C3C),
      elevatedButtonFg: Color(0xFFFFFFFF),
      fabBg: Color(0xFFE74C3C),
      fabFg: Color(0xFFFFFFFF),
      bottomNavBg: Color(0xFF141210),
      bottomNavSelected: Color(0xFFF5F0EB),
      bottomNavUnselected: Color(0xFF7A726A),
      shadow: Color(0x66000000),
    );
  }

  factory OpenWhenPalette.midnight() {
    return const OpenWhenPalette(
      brightness: Brightness.dark,
      bg: Color(0xFF0F1729),
      card: Color(0xFF1E293B),
      white: Color(0xFFF1F5F9),
      ink: Color(0xFFE2E8F0),
      inkSoft: Color(0xFF94A3B8),
      inkFaint: Color(0xFF64748B),
      accent: Color(0xFF3B82F6),
      accentWarm: Color(0xFF1E293B),
      accentDark: Color(0xFF2563EB),
      gold: Color(0xFFFBBF24),
      goldLight: Color(0xFF1E293B),
      border: Color(0xFF1E293B),
      divider: Color(0xFF1E293B),
      cardBorder: Color(0xFF334155),
      headerGradient: [
        Color(0xFF0B1220),
        Color(0xFF172554),
        Color(0xFF0B1220),
      ],
      elevatedButtonBg: Color(0xFF3B82F6),
      elevatedButtonFg: Color(0xFFFFFFFF),
      fabBg: Color(0xFF3B82F6),
      fabFg: Color(0xFFFFFFFF),
      bottomNavBg: Color(0xFF0C1426),
      bottomNavSelected: Color(0xFFF1F5F9),
      bottomNavUnselected: Color(0xFF64748B),
      shadow: Color(0x66000000),
    );
  }

  factory OpenWhenPalette.sepia() {
    return const OpenWhenPalette(
      brightness: Brightness.light,
      bg: Color(0xFFF5E6D3),
      card: Color(0xFFFFFBF5),
      white: Color(0xFFFFFBF5),
      ink: Color(0xFF3D2914),
      inkSoft: Color(0xFF6B5344),
      inkFaint: Color(0xFFA89888),
      accent: Color(0xFFB8860B),
      accentWarm: Color(0xFFEDE0CC),
      accentDark: Color(0xFF8B6914),
      gold: Color(0xFFC9A84C),
      goldLight: Color(0xFFF0E4D0),
      border: Color(0xFFE8D4BC),
      divider: Color(0xFFF0E4D0),
      cardBorder: Color(0xFFE8D4BC),
      headerGradient: [
        Color(0xFF3D2914),
        Color(0xFF5C3D1E),
        Color(0xFF3D2914),
      ],
      elevatedButtonBg: Color(0xFF3D2914),
      elevatedButtonFg: Color(0xFFFFFBF5),
      fabBg: Color(0xFFB8860B),
      fabFg: Color(0xFFFFFFFF),
      bottomNavBg: Color(0xFFFFFBF5),
      bottomNavSelected: Color(0xFF3D2914),
      bottomNavUnselected: Color(0xFFA89888),
      shadow: Color(0x333D2914),
    );
  }

  @override
  OpenWhenPalette copyWith({
    Brightness? brightness,
    Color? bg,
    Color? card,
    Color? white,
    Color? ink,
    Color? inkSoft,
    Color? inkFaint,
    Color? accent,
    Color? accentWarm,
    Color? accentDark,
    Color? gold,
    Color? goldLight,
    Color? border,
    Color? divider,
    Color? cardBorder,
    List<Color>? headerGradient,
    Color? elevatedButtonBg,
    Color? elevatedButtonFg,
    Color? fabBg,
    Color? fabFg,
    Color? bottomNavBg,
    Color? bottomNavSelected,
    Color? bottomNavUnselected,
    Color? shadow,
  }) {
    return OpenWhenPalette(
      brightness: brightness ?? this.brightness,
      bg: bg ?? this.bg,
      card: card ?? this.card,
      white: white ?? this.white,
      ink: ink ?? this.ink,
      inkSoft: inkSoft ?? this.inkSoft,
      inkFaint: inkFaint ?? this.inkFaint,
      accent: accent ?? this.accent,
      accentWarm: accentWarm ?? this.accentWarm,
      accentDark: accentDark ?? this.accentDark,
      gold: gold ?? this.gold,
      goldLight: goldLight ?? this.goldLight,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      cardBorder: cardBorder ?? this.cardBorder,
      headerGradient: headerGradient ?? this.headerGradient,
      elevatedButtonBg: elevatedButtonBg ?? this.elevatedButtonBg,
      elevatedButtonFg: elevatedButtonFg ?? this.elevatedButtonFg,
      fabBg: fabBg ?? this.fabBg,
      fabFg: fabFg ?? this.fabFg,
      bottomNavBg: bottomNavBg ?? this.bottomNavBg,
      bottomNavSelected: bottomNavSelected ?? this.bottomNavSelected,
      bottomNavUnselected: bottomNavUnselected ?? this.bottomNavUnselected,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  OpenWhenPalette lerp(ThemeExtension<OpenWhenPalette>? other, double t) {
    if (other is! OpenWhenPalette) return this;
    return t < 0.5 ? this : other;
  }
}

extension OpenWhenTheme on BuildContext {
  OpenWhenPalette get pal =>
      Theme.of(this).extension<OpenWhenPalette>() ?? OpenWhenPalette.classic();
}
