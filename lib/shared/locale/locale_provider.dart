import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    _syncToFirestore(p);
  }

  /// Best-effort sync of the resolved language code to Firestore so that
  /// server-side notifications (e.g. email-bounce) use the right locale.
  void _syncToFirestore(AppLocalePreference p) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Resolve to a 2-letter language code (same keys the webhook uses).
    final String langCode;
    switch (p) {
      case AppLocalePreference.ptBr:
        langCode = 'pt';
      case AppLocalePreference.en:
        langCode = 'en';
      case AppLocalePreference.es:
        langCode = 'es';
      case AppLocalePreference.system:
        // Use the device locale; best guess.
        final deviceLang =
            WidgetsBinding.instance.platformDispatcher.locale.languageCode;
        langCode = const {'pt', 'en', 'es'}.contains(deviceLang)
            ? deviceLang
            : 'en';
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'preferredLanguage': langCode})
        .catchError((_) {/* best-effort, ignore failures */});
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
