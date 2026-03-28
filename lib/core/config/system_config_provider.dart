import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/firestore_collections.dart';

/// Remote toggles from Firestore [`systemConfig/app`](FirestoreCollections).
/// If the document is missing, defaults keep the app fully usable.
class SystemConfig {
  final bool reportsEnabled;

  const SystemConfig({required this.reportsEnabled});

  factory SystemConfig.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    if (!snapshot.exists || snapshot.data() == null) {
      return const SystemConfig(reportsEnabled: true);
    }
    final m = snapshot.data()!;
    return SystemConfig(reportsEnabled: m['reportsEnabled'] != false);
  }
}

final systemConfigProvider = StreamProvider<SystemConfig>((ref) {
  return FirebaseFirestore.instance
      .collection(FirestoreCollections.systemConfig)
      .doc(FirestoreCollections.systemConfigAppDocId)
      .snapshots()
      .map(SystemConfig.fromSnapshot);
});
