import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'open_when_palette.dart';

export 'open_when_palette.dart';

class AppTheme {
  static ThemeData themeFromPalette(OpenWhenPalette p) {
    return ThemeData(
      scaffoldBackgroundColor: p.bg,
      cardColor: p.card,
      dialogBackgroundColor: p.card,
      colorScheme: ColorScheme.fromSeed(
        seedColor: p.accent,
        brightness: p.brightness,
        surface: p.bg,
      ),
      useMaterial3: true,
      brightness: p.brightness,
      extensions: [p],
      textTheme: TextTheme(
        displayLarge: GoogleFonts.dmSerifDisplay(
          fontSize: 26,
          color: p.ink,
          fontStyle: FontStyle.italic,
        ),
        titleLarge: GoogleFonts.dmSerifDisplay(
          fontSize: 20,
          color: p.ink,
        ),
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 15,
          color: p.ink,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 14,
          color: p.inkSoft,
          fontWeight: FontWeight.w300,
        ),
        labelLarge: GoogleFonts.dmSans(
          fontSize: 15,
          color: p.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.elevatedButtonBg,
          foregroundColor: p.elevatedButtonFg,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: p.shadow,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.inkSoft,
          side: BorderSide(color: p.inkFaint, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.fabBg,
        foregroundColor: p.fabFg,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        elevation: 8,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: p.bottomNavBg,
        selectedItemColor: p.bottomNavSelected,
        unselectedItemColor: p.bottomNavUnselected,
        selectedLabelStyle: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.dmSans(fontSize: 10),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
