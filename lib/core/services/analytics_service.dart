import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final _analytics = FirebaseAnalytics.instance;

  static FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // Autenticação
  static Future<void> logLogin() =>
      _analytics.logLogin(loginMethod: 'email');

  static Future<void> logSignUp() =>
      _analytics.logSignUp(signUpMethod: 'email');

  // Cartas
  static Future<void> logLetterCreated(String emotionalState) =>
      _analytics.logEvent(name: 'letter_created', parameters: {'emotional_state': emotionalState});

  static Future<void> logLetterOpened(String emotionalState) =>
      _analytics.logEvent(name: 'letter_opened', parameters: {'emotional_state': emotionalState});

  static Future<void> logLetterShared() =>
      _analytics.logEvent(name: 'letter_shared');

  static Future<void> logQrCodeGenerated() =>
      _analytics.logEvent(name: 'qr_code_generated');

  // Cápsulas
  static Future<void> logCapsuleCreated(String theme) =>
      _analytics.logEvent(name: 'capsule_created', parameters: {'theme': theme});

  static Future<void> logCapsuleOpened(String theme) =>
      _analytics.logEvent(name: 'capsule_opened', parameters: {'theme': theme});

  // Feed e social
  static Future<void> logFeedViewed(String layer) =>
      _analytics.logEvent(name: 'feed_viewed', parameters: {'layer': layer});

  static Future<void> logLetterLiked() =>
      _analytics.logEvent(name: 'letter_liked');

  static Future<void> logCommentAdded() =>
      _analytics.logEvent(name: 'comment_added');

  static Future<void> logUserFollowed() =>
      _analytics.logEvent(name: 'user_followed');

  // Perfil
  static Future<void> logProfileViewed() =>
      _analytics.logEvent(name: 'profile_viewed');

  static Future<void> logAvatarUpdated() =>
      _analytics.logEvent(name: 'avatar_updated');

  // Configurações
  static Future<void> logThemeChanged(String theme) =>
      _analytics.logEvent(name: 'theme_changed', parameters: {'theme': theme});

  static Future<void> logLanguageChanged(String language) =>
      _analytics.logEvent(name: 'language_changed', parameters: {'language': language});

  // Export
  static Future<void> logLetterExported(String format) =>
      _analytics.logEvent(name: 'letter_exported', parameters: {'format': format});

  // Screen views
  static Future<void> logScreenView(String screenName) =>
      _analytics.logScreenView(screenName: screenName);
}
