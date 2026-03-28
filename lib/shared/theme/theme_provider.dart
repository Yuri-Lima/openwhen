import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'open_when_palette.dart';

/// Persisted app theme selection.
enum AppThemeMode {
  system,
  classic,
  dark,
  midnight,
  sepia,
}

const _kThemeKey = 'app_theme_mode';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, AppThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() {
    Future.microtask(_load);
    return AppThemeMode.system;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kThemeKey);
    if (raw == null) return;
    try {
      final mode = AppThemeMode.values.byName(raw);
      if (state != mode) state = mode;
    } catch (_) {}
  }

  Future<void> setMode(AppThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeKey, mode.name);
  }
}

/// Resolves [OpenWhenPalette] from user preference + platform brightness.
OpenWhenPalette resolvePalette(AppThemeMode mode, Brightness platformBrightness) {
  switch (mode) {
    case AppThemeMode.system:
      return platformBrightness == Brightness.dark
          ? OpenWhenPalette.dark()
          : OpenWhenPalette.classic();
    case AppThemeMode.classic:
      return OpenWhenPalette.classic();
    case AppThemeMode.dark:
      return OpenWhenPalette.dark();
    case AppThemeMode.midnight:
      return OpenWhenPalette.midnight();
    case AppThemeMode.sepia:
      return OpenWhenPalette.sepia();
  }
}
