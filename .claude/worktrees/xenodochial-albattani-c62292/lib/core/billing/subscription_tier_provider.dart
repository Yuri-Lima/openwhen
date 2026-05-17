import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../constants/firestore_collections.dart';
import 'subscription_tier.dart';

/// Live subscription tier from Firestore (defaults to free).
final subscriptionTierProvider = StreamProvider<SubscriptionTier>((ref) {
  final user = ref.watch(authStateProvider).asData?.value;
  final uid = user?.uid;
  if (uid == null) {
    return Stream.value(SubscriptionTier.free);
  }
  return FirebaseFirestore.instance
      .collection(FirestoreCollections.users)
      .doc(uid)
      .snapshots()
      .map((s) {
    final raw = s.data()?['subscriptionTier'] as String?;
    return subscriptionTierFromId(raw);
  });
});
