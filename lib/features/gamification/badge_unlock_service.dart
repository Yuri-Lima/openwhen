import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_collections.dart';
import 'badge_id.dart';

/// Persists unlock under `users/{uid}/badgeUnlocks/{badgeId}` (rules allowlist).
Future<void> unlockBadgeIfMissing(String uid, String badgeId) async {
  if (!BadgeId.all.contains(badgeId)) return;
  final ref = FirebaseFirestore.instance
      .collection(FirestoreCollections.users)
      .doc(uid)
      .collection('badgeUnlocks')
      .doc(badgeId);
  final snap = await ref.get();
  if (snap.exists) return;
  await ref.set({'unlockedAt': FieldValue.serverTimestamp()});
}

class BadgeUnlockHooks {
  BadgeUnlockHooks._();

  static Future<void> afterLetterSent({
    required String senderUid,
    required bool hasVoice,
  }) async {
    final userRef = FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(senderUid);
    await userRef.update({'lettersSentCount': FieldValue.increment(1)});
    final snap = await userRef.get();
    final cnt = (snap.data()?['lettersSentCount'] as num?)?.toInt() ?? 0;
    if (cnt == 1) {
      await unlockBadgeIfMissing(senderUid, BadgeId.firstLetterSent);
    }
    if (cnt >= 5) {
      await unlockBadgeIfMissing(senderUid, BadgeId.lettersSentFive);
    }
    if (cnt >= 10) {
      await unlockBadgeIfMissing(senderUid, BadgeId.lettersSentTen);
    }
    if (hasVoice) {
      await unlockBadgeIfMissing(senderUid, BadgeId.voiceLetter);
    }
  }

  static Future<void> afterLetterOpenedByReceiver(String receiverUid) async {
    final userRef = FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(receiverUid);
    await userRef.update({'openedLettersCount': FieldValue.increment(1)});
    final snap = await userRef.get();
    final cnt = (snap.data()?['openedLettersCount'] as num?)?.toInt() ?? 0;
    if (cnt == 1) {
      await unlockBadgeIfMissing(receiverUid, BadgeId.firstLetterOpened);
    }
  }

  static Future<void> afterLetterMadePublic(String actorUid) async {
    await unlockBadgeIfMissing(actorUid, BadgeId.firstPublic);
  }
}
