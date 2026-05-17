/// Single source of truth for all whenote.app URLs and contact emails.
///
/// Every deep-link, legal page URL, or contact email that references the
/// `whenote.app` domain MUST come from this file so that a domain change
/// only requires editing one place.
class AppUrls {
  AppUrls._();

  // ---------------------------------------------------------------------------
  // Base
  // ---------------------------------------------------------------------------
  static const String baseUrl = 'https://whenote.app';

  // ---------------------------------------------------------------------------
  // Deep links
  // ---------------------------------------------------------------------------
  static String letterUrl(String docId) => '$baseUrl/letter/$docId';
  static String capsuleUrl(String docId) => '$baseUrl/capsule/$docId';
  static String openUrl(String token) => '$baseUrl/open/$token';

  // ---------------------------------------------------------------------------
  // Legal / policy pages
  // ---------------------------------------------------------------------------
  static const String privacyUrl = '$baseUrl/privacy.html';
  static const String termsUrl = '$baseUrl/terms.html';

  // ---------------------------------------------------------------------------
  // Contact emails
  // ---------------------------------------------------------------------------
  static const String supportEmail = 'suporte@whenote.app';
  static const String privacyEmail = 'privacidade@whenote.app';
  static const String legalEmail = 'juridico@whenote.app';
  static const String dpoEmail = 'dpo@whenote.app';
}
