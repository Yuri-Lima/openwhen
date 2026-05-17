/// Analytics consent status for ePrivacy / UK PECR compliance.
enum AnalyticsConsentStatus {
  /// User has not yet been asked (first launch or legacy user).
  pending,

  /// User explicitly accepted analytics collection.
  granted,

  /// User explicitly declined analytics collection.
  denied,
}

/// SharedPreferences key for the stored consent choice.
const kAnalyticsConsentKey = 'analytics_consent_status';

/// SharedPreferences key for the ISO-8601 timestamp of the consent decision.
const kAnalyticsConsentDateKey = 'analytics_consent_date';
