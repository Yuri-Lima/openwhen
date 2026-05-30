import 'package:flutter/foundation.dart';

/// When `false` (default), the app does not call Stripe / Cloud Functions for
/// checkout or portal — avoids errors until Stripe and env vars are configured.
///
/// Supplied via `--dart-define-from-file=config/dart_defines.json`
const kBillingStripeEnabled = bool.fromEnvironment('BILLING_ENABLED');

/// Whether any subscription / purchase UI (plans screen, upgrade CTAs) may be
/// shown on the current platform.
///
/// Disabled on iOS to comply with App Store Review Guideline 3.1.1: paid
/// digital content must be sold via In-App Purchase, and external payment
/// (Stripe Checkout in the browser) is not allowed. Until native StoreKit IAP
/// is implemented, all purchase entry points are hidden on iOS. Web and
/// Android continue to use Stripe.
bool get kSubscriptionsUiEnabled =>
    kIsWeb || defaultTargetPlatform != TargetPlatform.iOS;
