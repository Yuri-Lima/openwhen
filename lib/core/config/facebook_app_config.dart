/// Facebook / Meta App ID for Instagram Sharing to Stories (client-side; not a secret).
/// Pass at build time: `--dart-define=FB_APP_ID=your_app_id`
const String kFacebookAppId = String.fromEnvironment(
  'FB_APP_ID',
  defaultValue: '',
);

bool get kFacebookAppIdConfigured => kFacebookAppId.isNotEmpty;
