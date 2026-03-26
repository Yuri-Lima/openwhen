import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User-selected UI language, or follow the device.
enum AppLocalePreference {
  system,
  ptBr,
  en,
  es,
}

const _kLocaleKey = 'app_locale_pref';

final localePreferenceProvider =
    NotifierProvider<LocalePreferenceNotifier, AppLocalePreference>(
  LocalePreferenceNotifier.new,
);

class LocalePreferenceNotifier extends Notifier<AppLocalePreference> {
  @override
  AppLocalePreference build() {
    Future.microtask(_load);
    return AppLocalePreference.system;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kLocaleKey);
    if (raw == null) return;
    try {
      final m = AppLocalePreference.values.byName(raw);
      if (state != m) state = m;
    } catch (_) {}
  }

  Future<void> setPreference(AppLocalePreference p) async {
    state = p;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, p.name);
  }
}

/// Resolves [Locale] for [MaterialApp] from preference + device locale.
Locale resolveAppLocale(AppLocalePreference pref, Locale platformLocale) {
  switch (pref) {
    case AppLocalePreference.system:
      final lang = platformLocale.languageCode.toLowerCase();
      if (lang == 'pt') return const Locale('pt', 'BR');
      if (lang == 'es') return const Locale('es');
      if (lang == 'en') return const Locale('en');
      return const Locale('pt', 'BR');
    case AppLocalePreference.ptBr:
      return const Locale('pt', 'BR');
    case AppLocalePreference.en:
      return const Locale('en');
    case AppLocalePreference.es:
      return const Locale('es');
  }
}
