import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;

import '../services/callable_queue.dart';
import 'billing_provider.dart';
import 'firebase_functions_region.dart';
import 'subscription_tier.dart';

/// Checkout/portal disabled; migration callable still runs (no Stripe keys needed).
class DisabledBillingProvider implements BillingProvider {
  @override
  Future<Uri> createCheckoutSession({
    required SubscriptionTier plan,
    required Uri successUrl,
    required Uri cancelUrl,
  }) async {
    throw StateError('Billing is not enabled (set BILLING_ENABLED=true)');
  }

  @override
  Future<Uri> createPortalSession({required Uri returnUrl}) async {
    throw StateError('Billing is not enabled (set BILLING_ENABLED=true)');
  }

  @override
  Future<void> migrateBillingDefaultsIfNeeded() async {
    try {
      await CallableQueue.enqueue(
        () => FirebaseFunctions.instanceFor(region: kFirebaseFunctionsRegion)
            .httpsCallable('migrateUserBillingDefaults')
            .call(),
        label: 'migrateUserBillingDefaults',
      );
    } catch (e, st) {
      if (kDebugMode) debugPrint('[Billing] migrateDefaults: $e\n$st');
    }
  }
}
