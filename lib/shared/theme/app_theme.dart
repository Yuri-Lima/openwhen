import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color bg         = Color(0xFFF7F4F0);
  static const Color white      = Color(0xFFFFFFFF);
  static const Color ink        = Color(0xFF1A1714);
  static const Color inkSoft    = Color(0xFF6B6560);
  static const Color inkFaint   = Color(0xFFC4BFB9);
  static const Color accent     = Color(0xFFC0392B);
  static const Color accentWarm = Color(0xFFF0EAE4);
  static const Color accentDark = Color(0xFFA93226);
  static const Color gold       = Color(0xFFC9A84C);
  static const Color goldLight  = Color(0xFFF5EDD6);
  static const Color border     = Color(0xFFEDE8E3);
  static const Color divider    = Color(0xFFF5F0EB);
  // alias para compatibilidade
  static const Color cardBorder = Color(0xFFEDE8E3);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent),
      useMaterial3: true,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.dmSerifDisplay(
          fontSize: 26,
          color: AppColors.ink,
          fontStyle: FontStyle.italic,
        ),
        titleLarge: GoogleFonts.dmSerifDisplay(
          fontSize: 20,
          color: AppColors.ink,
        ),
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 15,
          color: AppColors.ink,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 14,
          color: AppColors.inkSoft,
          fontWeight: FontWeight.w300,
        ),
        labelLarge: GoogleFonts.dmSans(
          fontSize: 15,
          color: AppColors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: Color(0x331A1714),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.inkSoft,
          side: const BorderSide(color: AppColors.inkFaint, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        elevation: 8,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.ink,
        unselectedItemColor: AppColors.inkFaint,
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
