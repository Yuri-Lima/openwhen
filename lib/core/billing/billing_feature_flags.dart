/// When `false` (default), the app does not call Stripe / Cloud Functions for
/// checkout or portal — avoids errors until Stripe and env vars are configured.
///
/// Enable for production: `--dart-define=BILLING_ENABLED=true`
const kBillingStripeEnabled = bool.fromEnvironment(
  'BILLING_ENABLED',
  defaultValue: false,
);
