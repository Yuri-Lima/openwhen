/// Subscription tiers (IDs match Firestore `subscriptionTier` and Stripe mapping).
enum SubscriptionTier {
  /// Amanhã — free tier
  free,

  /// Brisa — paid
  plus,

  /// Horizonte — paid
  pro,
}

SubscriptionTier subscriptionTierFromId(String? raw) {
  if (raw == null || raw.isEmpty) return SubscriptionTier.free;
  switch (raw) {
    case 'plus':
      return SubscriptionTier.plus;
    case 'pro':
      return SubscriptionTier.pro;
    case 'free':
    default:
      return SubscriptionTier.free;
  }
}

String subscriptionTierId(SubscriptionTier tier) {
  switch (tier) {
    case SubscriptionTier.free:
      return 'free';
    case SubscriptionTier.plus:
      return 'plus';
    case SubscriptionTier.pro:
      return 'pro';
  }
}

/// Whether [current] satisfies [required] (same tier or higher).
bool tierMeets(SubscriptionTier current, SubscriptionTier required) {
  return current.index >= required.index;
}
