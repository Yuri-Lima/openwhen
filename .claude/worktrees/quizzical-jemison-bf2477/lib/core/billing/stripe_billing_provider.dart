import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/safe_callable.dart';

import 'billing_feature_flags.dart';
import 'billing_provider.dart';
import 'disabled_billing_provider.dart';
import 'subscription_tier.dart';

/// Stripe via Firebase Callable Functions (Checkout + Portal + webhooks).
class StripeBillingProvider implements BillingProvider {
  @override
  Future<Uri> createCheckoutSession({
    required SubscriptionTier plan,
    required Uri successUrl,
    required Uri cancelUrl,
  }) async {
    final planId = plan == SubscriptionTier.plus ? 'plus' : 'pro';
    final result = await SafeCallable.call(
      'createCheckoutSession',
      data: <String, dynamic>{
        'planId': planId,
        'successUrl': successUrl.toString(),
        'cancelUrl': cancelUrl.toString(),
      },
      label: 'createCheckoutSession',
    );
    final data = Map<String, dynamic>.from(result.data as Map);
    final url = data['url'] as String?;
    if (url == null || url.isEmpty) {
      throw StateError('createCheckoutSession: empty url');
    }
    return Uri.parse(url);
  }

  @override
  Future<Uri> createPortalSession({required Uri returnUrl}) async {
    final result = await SafeCallable.call(
      'createPortalSession',
      data: <String, dynamic>{
        'returnUrl': returnUrl.toString(),
      },
      label: 'createPortalSession',
    );
    final data = Map<String, dynamic>.from(result.data as Map);
    final url = data['url'] as String?;
    if (url == null || url.isEmpty) {
      throw StateError('createPortalSession: empty url');
    }
    return Uri.parse(url);
  }

  @override
  Future<void> migrateBillingDefaultsIfNeeded() async {
    try {
      await SafeCallable.call(
        'migrateUserBillingDefaults',
        label: 'migrateUserBillingDefaults',
      );
    } catch (e, st) {
      if (kDebugMode) debugPrint('[Billing] migrateDefaults: $e\n$st');
    }
  }
}

final billingProvider = Provider<BillingProvider>((ref) {
  if (!kBillingStripeEnabled) {
    return DisabledBillingProvider();
  }
  return StripeBillingProvider();
});
