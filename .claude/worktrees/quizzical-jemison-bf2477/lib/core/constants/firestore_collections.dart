class FirestoreCollections {
  static const String users = 'users';
  static const String letters = 'letters';
  static const String comments = 'comments';
  static const String likes = 'likes';
  static const String reports = 'reports';
  static const String capsules = 'capsules';
  static const String follows = 'follows';
  static const String blocks = 'blocks';
  static const String feedback = 'feedback';
  /// Ops / IA — escrita só Admin SDK; leitura no app via callable `adminListModerationIncidents`.
  static const String moderationIncidents = 'moderationIncidents';
  /// Fila humana — escrita só Functions; leitura admin via callable.
  static const String moderationReviews = 'moderationReviews';
  /// Subcoleção de `users/{uid}` — notificações (ex.: moderação); escrita só Functions.
  static const String userNotifications = 'notifications';
  static const String systemConfig = 'systemConfig';
  /// Logs de auditoria de deleção de conta (sem PII) — escrita só Cloud Function.
  static const String deletionAuditLogs = 'deletionAuditLogs';
  /// Log unificado de todas as ações de privacidade (export, deleção, anonimização).
  /// Escrita: cliente (export) + Cloud Function (deleção/anonimização).
  static const String privacyRequestLogs = 'privacyRequestLogs';

  /// Remote feature flags (`reportsEnabled`, etc.); read-only for clients.
  static const String systemConfigAppDocId = 'app';
}
