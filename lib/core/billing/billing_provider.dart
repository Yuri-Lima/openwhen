import 'package:flutter/foundation.dart';
import 'subscription_tier.dart';

/// Pluggable billing backend (Stripe, IAP, etc.).
@immutable
abstract class BillingProvider {
  /// Opens Stripe Checkout for [plan] (plus / pro).
  Future<Uri> createCheckoutSession({
    required SubscriptionTier plan,
    required Uri successUrl,
    required Uri cancelUrl,
  });

  /// Stripe Customer Portal when the user already has a Stripe customer id.
  Future<Uri> createPortalSession({required Uri returnUrl});

  /// Optional: server-side migration for legacy users missing `subscriptionTier`.
  Future<void> migrateBillingDefaultsIfNeeded();
}
