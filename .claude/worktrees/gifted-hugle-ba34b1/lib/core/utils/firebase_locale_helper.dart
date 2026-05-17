import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';

/// Sets the Firebase Auth language code to match the user's current locale.
///
/// Must be called **before** any email-sending method
/// (`sendEmailVerification`, `sendPasswordResetEmail`, etc.)
/// so Firebase delivers the template in the correct language.
///
/// Supported languages: pt, en, es (falls back to 'en').
Future<void> applyFirebaseLocale() async {
  final lang = PlatformDispatcher.instance.locale.languageCode;
  final supported = const {'pt', 'en', 'es'};
  FirebaseAuth.instance.setLanguageCode(
    supported.contains(lang) ? lang : 'en',
  );
}
