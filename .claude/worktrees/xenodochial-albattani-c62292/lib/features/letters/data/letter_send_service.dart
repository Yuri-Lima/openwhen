import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants/firestore_collections.dart';
import '../../gamification/badge_id.dart';
import '../../gamification/badge_unlock_service.dart';
import 'letter_send_step.dart';

/// Atomic Firestore commit for sending a letter: `letters` create + `users` stats + `badgeUnlocks`.
class LetterSendService {
  LetterSendService._();

  static void _log(LetterSendStep step, String message, [Object? error]) {
    if (!kDebugMode) return;
    developer.log(
      '[LetterSend] $message step=${step.name}${error != null ? ' error=$error' : ''}',
      name: 'LetterSend',
    );
  }

  /// Runs a single transaction: letter document, increment `lettersSentCount`, badge unlocks as needed.
  /// Returns the generated letter document ID.
  static Future<String> commitLetterSend({
    required FirebaseFirestore firestore,
    required String senderUid,
    required Map<String, dynamic> letterData,
    required bool hasVoice,
  }) async {
    const step = LetterSendStep.commitFirestore;
    _log(step, 'start');
    final userRef = firestore.collection(FirestoreCollections.users).doc(senderUid);
    final letterRef = firestore.collection(FirestoreCollections.letters).doc();

    await firestore.runTransaction((transaction) async {
      final userSnap = await transaction.get(userRef);
      final oldCount = (userSnap.data()?['lettersSentCount'] as num?)?.toInt() ?? 0;
      final newCount = oldCount + 1;

      final badgeIdsToMaybeCreate = <String>[];
      if (newCount == 1) badgeIdsToMaybeCreate.add(BadgeId.firstLetterSent);
      if (newCount >= 5) badgeIdsToMaybeCreate.add(BadgeId.lettersSentFive);
      if (newCount >= 10) badgeIdsToMaybeCreate.add(BadgeId.lettersSentTen);
      if (hasVoice) badgeIdsToMaybeCreate.add(BadgeId.voiceLetter);

      final badgeSnaps = <String, DocumentSnapshot<Map<String, dynamic>>>{};
      for (final id in badgeIdsToMaybeCreate) {
        final bref = userRef.collection('badgeUnlocks').doc(id);
        badgeSnaps[id] = await transaction.get(bref);
      }

      transaction.set(letterRef, letterData);
      transaction.update(userRef, {'lettersSentCount': FieldValue.increment(1)});

      for (final id in badgeIdsToMaybeCreate) {
        final snap = badgeSnaps[id]!;
        if (!snap.exists) {
          transaction.set(userRef.collection('badgeUnlocks').doc(id), {
            'unlockedAt': FieldValue.serverTimestamp(),
          });
        }
      }
    });

    // Award "first letter received" badge to the receiver (outside transaction).
    final receiverUid = letterData['receiverUid'] as String?;
    if (receiverUid != null && receiverUid.isNotEmpty) {
      // Fire-and-forget — don't block the send flow.
      BadgeUnlockHooks.afterLetterReceivedByUser(receiverUid);
    }

    _log(step, 'done');
    return letterRef.id;
  }
}
