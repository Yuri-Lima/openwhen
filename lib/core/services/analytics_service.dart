import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final _analytics = FirebaseAnalytics.instance;

  /// Whether analytics collection is currently enabled.
  /// Starts `false` — only set to `true` after consent is verified.
  static bool _enabled = false;

  /// Called once at app startup to disable collection before any events fire.
  static Future<void> disableByDefault() async {
    _enabled = false;
    await _analytics.setAnalyticsCollectionEnabled(false);
  }

  /// Called when consent status is determined (from storage or user action).
  static Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    await _analytics.setAnalyticsCollectionEnabled(enabled);
  }

  static final observer = FirebaseAnalyticsObserver(analytics: _analytics);

  // Autenticação
  static Future<void> logLogin({String method = 'email'}) async {
    if (!_enabled) return;
    await _analytics.logLogin(loginMethod: method);
  }

  static Future<void> logSignUp() async {
    if (!_enabled) return;
    await _analytics.logSignUp(signUpMethod: 'email');
  }

  // Cartas
  static Future<void> logLetterCreated(String emotionalState) async {
    if (!_enabled) return;
    await _analytics.logEvent(name: 'letter_created', parameters: {'emotional_state': emotionalState});
  }

  static Future<void> logExternalLettersClaimed(int count) async {
    if (!_enabled) return;
    await _analytics.logEvent(name: 'external_letters_claimed', parameters: {'count': count});
  }

  static Future<void> logLetterOpened(String emotionalState) async {
    if (!_enabled) return;
    await _analytics.logEvent(name: 'letter_opened', parameters: {'emotional_state': emotionalState});
  }

  static Future<void> logLetterShared() async {
    if (!_enabled) return;
    await _analytics.logEvent(name: 'letter_shared');
  }

  static Future<void> logQrCodeGenerated() async {
    if (!_enabled) return;
    await _analytics.logEvent(name: 'qr_code_generated');
  }

  // Cápsulas
  static Future<void> logCapsuleCreated(String theme) async {
    if (!_enabled) return;
    await _analytics.logEvent(name: 'capsule_created', parameters: {'theme': theme});
  }

  static Future<void> logCapsuleOpened(String theme) async {
    if (!_enabled) return;
    await _analytics.logEvent(name: 'capsule_opened', parameters: {'theme': theme});
  }

  // Feed e social
  static Future<void> logFeedViewed(String layer) async {
    if (!_enabled) return;
    await _analytics.logEvent(name: 'feed_viewed', parameters: {'layer': layer});
  }

  static Future<void> logLetterLiked() async {
    if (!_enabled) return;
    await _analytics.logEvent(name: 'letter_liked');
  }

  static Future<void> logCommentAdded() async {
    if (!_enabled) return;
    await _analytics.logEvent(name: 'comment_added');
  }

  static Future<void> logUserFollowed() async {
    if (!_enabled) return;
    await _analytics.logEvent(name: 'user_followed');
  }

  // Perfil
  static Future<void> logProfileViewed() async {
    if (!_enabled) return;
    await _analytics.logEvent(name: 'profile_viewed');
  }

  static Future<void> logAvatarUpdated() async {
    if (!_enabled) return;
    await _analytics.logEvent(name: 'avatar_updated');
  }

  // Configurações
  static Future<void> logThemeChanged(String theme) async {
    if (!_enabled) return;
    await _analytics.logEvent(name: 'theme_changed', parameters: {'theme': theme});
  }

  static Future<void> logLanguageChanged(String language) async {
    if (!_enabled) return;
    await _analytics.logEvent(name: 'language_changed', parameters: {'language': language});
  }

  // Export
  static Future<void> logLetterExported(String format) async {
    if (!_enabled) return;
    await _analytics.logEvent(name: 'letter_exported', parameters: {'format': format});
  }

  // Screen views
  static Future<void> logScreenView(String screenName) async {
    if (!_enabled) return;
    await _analytics.logScreenView(screenName: screenName);
  }
}
