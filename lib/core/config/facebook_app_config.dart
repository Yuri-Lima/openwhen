/// Facebook / Meta App ID for Instagram Sharing to Stories (client-side; not a secret).
/// Supplied via `--dart-define-from-file=config/dart_defines.json`
const String kFacebookAppId = String.fromEnvironment('FB_APP_ID');

bool get kFacebookAppIdConfigured => kFacebookAppId.isNotEmpty;
