/// When `false` (default), the app does not call Stripe / Cloud Functions for
/// checkout or portal — avoids errors until Stripe and env vars are configured.
///
/// Supplied via `--dart-define-from-file=config/dart_defines.json`
const kBillingStripeEnabled = bool.fromEnvironment('BILLING_ENABLED');
