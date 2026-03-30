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
  /// When true, borderline/flagged comments go to human review queue (requires `letterId` on moderateContent).
  final bool humanModerationQueueEnabled;
  /// If set, max OpenAI category score above this triggers review when queue is enabled. Omit for flag-only.
  final double? moderationReviewScoreThreshold;

  const SystemConfig({
    required this.reportsEnabled,
    required this.aiModerationEnabled,
    required this.aiModerationFailClosed,
    required this.humanModerationQueueEnabled,
    required this.moderationReviewScoreThreshold,
  });

  factory SystemConfig.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    if (!snapshot.exists || snapshot.data() == null) {
      return const SystemConfig(
        reportsEnabled: true,
        aiModerationEnabled: true,
        aiModerationFailClosed: true,
        humanModerationQueueEnabled: true,
        moderationReviewScoreThreshold: 0.2,
      );
    }
    final m = snapshot.data()!;
    final thr = m['moderationReviewScoreThreshold'];
    return SystemConfig(
      reportsEnabled: m['reportsEnabled'] != false,
      aiModerationEnabled: m['aiModerationEnabled'] == true,
      aiModerationFailClosed: m['aiModerationFailClosed'] != false,
      humanModerationQueueEnabled: m['humanModerationQueueEnabled'] == true,
      moderationReviewScoreThreshold: thr is num ? thr.toDouble() : null,
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
