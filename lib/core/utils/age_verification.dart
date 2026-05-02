import 'dart:io' show Platform;

/// ISO 3166-1 alpha-2 country codes for EU/EEA member states + UK
/// where GDPR Art. 8 applies (minimum age for data processing consent).
const _euEeaUkCountries = <String>{
  // EU member states
  'AT', 'BE', 'BG', 'HR', 'CY', 'CZ', 'DK', 'EE', 'FI', 'FR',
  'DE', 'GR', 'HU', 'IE', 'IT', 'LV', 'LT', 'LU', 'MT', 'NL',
  'PL', 'PT', 'RO', 'SK', 'SI', 'ES', 'SE',
  // EEA (non-EU)
  'IS', 'LI', 'NO',
  // UK (post-Brexit, UK GDPR still applies)
  'GB',
};

/// Countries that have set a lower minimum age than 16 under GDPR Art. 8(1).
/// Source: https://gdpr-info.eu/art-8-gdpr/ + national implementations.
/// If a country is in the EU/EEA but NOT in this map, the default of 16 applies.
const _lowerAgeByCountry = <String, int>{
  'AT': 14, // Austria
  'BE': 13, // Belgium
  'CY': 14, // Cyprus
  'CZ': 15, // Czech Republic
  'DK': 13, // Denmark
  'EE': 13, // Estonia
  'FI': 13, // Finland
  'FR': 15, // France
  'DE': 16, // Germany (default)
  'GB': 13, // UK
  'GR': 15, // Greece
  'HR': 14, // Croatia
  'HU': 16, // Hungary (default)
  'IS': 13, // Iceland
  'IT': 14, // Italy
  'LI': 14, // Liechtenstein
  'LV': 13, // Latvia
  'LT': 14, // Lithuania
  'LU': 16, // Luxembourg (default)
  'MT': 13, // Malta
  'NO': 13, // Norway
  'PL': 16, // Poland (default)
  'PT': 13, // Portugal
  'SI': 14, // Slovenia
  'ES': 14, // Spain
  'SE': 13, // Sweden
  'SK': 16, // Slovakia (default)
};

/// Returns `true` if the device locale indicates an EU/EEA/UK jurisdiction
/// where ePrivacy Directive / UK PECR requires prior consent for analytics.
///
/// Fail-safe: if the country code cannot be determined, assumes EU (`true`)
/// — it is legally safer to show the consent banner unnecessarily than to
/// skip it for a user who actually needs it.
bool isEuEeaUkJurisdiction([String? overrideLocale]) {
  final country = _extractCountryCode(overrideLocale);
  if (country == null) return true; // fail-safe: assume EU
  return _euEeaUkCountries.contains(country);
}

/// Returns the minimum age required for the user's jurisdiction.
///
/// Uses the device locale to infer the user's country:
/// - EU/EEA/UK: country-specific minimum (13–16) per GDPR Art. 8
/// - All others: 13 (COPPA baseline)
int getMinimumAgeForLocale([String? overrideLocale]) {
  final country = _extractCountryCode(overrideLocale);
  if (country == null) return 13;

  if (_euEeaUkCountries.contains(country)) {
    return _lowerAgeByCountry[country] ?? 16;
  }

  return 13; // COPPA baseline for non-EU/EEA/UK
}

/// Checks whether a given [dateOfBirth] meets the minimum age requirement
/// for the user's jurisdiction.
///
/// Returns `null` if valid, or an error key string if underage.
String? validateAge(DateTime dateOfBirth, [String? overrideLocale]) {
  final minAge = getMinimumAgeForLocale(overrideLocale);
  final today = DateTime.now();
  final age = _calculateAge(dateOfBirth, today);

  if (age < minAge) {
    return 'underage'; // caller maps this to localized message
  }
  return null;
}

/// Calculates exact age in years from [birthDate] to [today].
int _calculateAge(DateTime birthDate, DateTime today) {
  int age = today.year - birthDate.year;
  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }
  return age;
}

/// Extracts a 2-letter ISO country code from the device locale.
///
/// Examples: `en_US` → `US`, `pt_BR` → `BR`, `de_DE` → `DE`.
String? _extractCountryCode([String? overrideLocale]) {
  try {
    final locale = overrideLocale ?? Platform.localeName; // e.g. 'en_US'
    // Handle formats: en_US, en-US, en_US.UTF-8
    final cleaned = locale.split('.').first; // strip .UTF-8
    final parts = cleaned.split(RegExp(r'[_-]'));
    if (parts.length >= 2) {
      return parts[1].toUpperCase();
    }
    return null;
  } catch (_) {
    return null;
  }
}
