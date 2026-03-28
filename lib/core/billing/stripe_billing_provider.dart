import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'billing_feature_flags.dart';
import 'billing_provider.dart';
import 'disabled_billing_provider.dart';
import 'firebase_functions_region.dart';
import 'subscription_tier.dart';

/// Stripe via Firebase Callable Functions (Checkout + Portal + webhooks).
class StripeBillingProvider implements BillingProvider {
  StripeBillingProvider({FirebaseFunctions? functions})
      : _functions =
            functions ?? FirebaseFunctions.instanceFor(region: kFirebaseFunctionsRegion);

  final FirebaseFunctions _functions;

  @override
  Future<Uri> createCheckoutSession({
    required SubscriptionTier plan,
    required Uri successUrl,
    required Uri cancelUrl,
  }) async {
    final planId = plan == SubscriptionTier.plus ? 'plus' : 'pro';
    final callable = _functions.httpsCallable('createCheckoutSession');
    final result = await callable.call(<String, dynamic>{
      'planId': planId,
      'successUrl': successUrl.toString(),
      'cancelUrl': cancelUrl.toString(),
    });
    final data = Map<String, dynamic>.from(result.data as Map);
    final url = data['url'] as String?;
    if (url == null || url.isEmpty) {
      throw StateError('createCheckoutSession: empty url');
    }
    return Uri.parse(url);
  }

  @override
  Future<Uri> createPortalSession({required Uri returnUrl}) async {
    final callable = _functions.httpsCallable('createPortalSession');
    final result = await callable.call(<String, dynamic>{
      'returnUrl': returnUrl.toString(),
    });
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
      await _functions.httpsCallable('migrateUserBillingDefaults').call();
    } catch (_) {
      // Best-effort; client still treats missing tier as free.
    }
  }
}

final billingProvider = Provider<BillingProvider>((ref) {
  if (!kBillingStripeEnabled) {
    return DisabledBillingProvider();
  }
  return StripeBillingProvider();
});
