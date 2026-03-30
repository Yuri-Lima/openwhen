import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/firestore_collections.dart';

/// Remote toggles from Firestore [`systemConfig/app`](FirestoreCollections).
/// If the document is missing, defaults keep the app fully usable.
class SystemConfig {
  final bool reportsEnabled;
  /// When true, client calls `moderateContent` before posting (e.g. comments).
  final bool aiModerationEnabled;
  /// When true and the moderation provider fails, block posting (strict). Defaults to true; set `false` in Firestore for soft fallback.
  final bool aiModerationFailClosed;

  const SystemConfig({
    required this.reportsEnabled,
    required this.aiModerationEnabled,
    required this.aiModerationFailClosed,
  });

  factory SystemConfig.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    if (!snapshot.exists || snapshot.data() == null) {
      return const SystemConfig(
        reportsEnabled: true,
        aiModerationEnabled: false,
        aiModerationFailClosed: true,
      );
    }
    final m = snapshot.data()!;
    return SystemConfig(
      reportsEnabled: m['reportsEnabled'] != false,
      aiModerationEnabled: m['aiModerationEnabled'] == true,
      aiModerationFailClosed: m['aiModerationFailClosed'] != false,
    );
  }
}

final systemConfigProvider = StreamProvider<SystemConfig>((ref) {
  return FirebaseFirestore.instance
      .collection(FirestoreCollections.systemConfig)
      .doc(FirestoreCollections.systemConfigAppDocId)
      .snapshots()
      .map(SystemConfig.fromSnapshot);
});
