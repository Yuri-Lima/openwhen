class FirestoreCollections {
  static const String users = 'users';
  static const String letters = 'letters';
  static const String comments = 'comments';
  static const String likes = 'likes';
  static const String reports = 'reports';
  static const String capsules = 'capsules';
  static const String feedback = 'feedback';
  /// Ops / IA — escrita só Admin SDK; leitura no app via callable `adminListModerationIncidents`.
  static const String moderationIncidents = 'moderationIncidents';
  static const String systemConfig = 'systemConfig';

  /// Remote feature flags (`reportsEnabled`, etc.); read-only for clients.
  static const String systemConfigAppDocId = 'app';
}
