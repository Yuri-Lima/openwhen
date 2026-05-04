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

  // ── Existing hooks ──────────────────────────────────────────────

  static Future<void> afterLetterOpenedByReceiver(String receiverUid) async {
    final userRef = FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(receiverUid);
    await userRef.update({'openedLettersCount': FieldValue.increment(1)});
    final snap = await userRef.get();
    final cnt =
        (snap.data()?['openedLettersCount'] as num?)?.toInt() ?? 0;
    if (cnt == 1) {
      await unlockBadgeIfMissing(receiverUid, BadgeId.firstLetterOpened);
    }
  }

  static Future<void> afterLetterMadePublic(String actorUid) async {
    await unlockBadgeIfMissing(actorUid, BadgeId.firstPublic);
  }

  // ── New hooks ───────────────────────────────────────────────────

  /// Call when a letter is delivered to [receiverUid] (i.e. the letter doc is
  /// created with `receiverUid`). Increments `lettersReceivedCount` and awards
  /// the badge on the first one.
  static Future<void> afterLetterReceivedByUser(String receiverUid) async {
    final userRef = FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(receiverUid);
    await userRef.update({
      'lettersReceivedCount': FieldValue.increment(1),
    });
    final snap = await userRef.get();
    final cnt =
        (snap.data()?['lettersReceivedCount'] as num?)?.toInt() ?? 0;
    if (cnt == 1) {
      await unlockBadgeIfMissing(receiverUid, BadgeId.firstLetterReceived);
    }
  }

  /// Call after a profile save. Checks whether all required fields are filled
  /// (name, username, bio, photoUrl) and awards the badge if so.
  static Future<void> afterProfileSaved(String uid) async {
    final snap = await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(uid)
        .get();
    final data = snap.data();
    if (data == null) return;

    final name = (data['displayName'] as String?)?.trim() ?? '';
    final username = (data['username'] as String?)?.trim() ?? '';
    final bio = (data['bio'] as String?)?.trim() ?? '';
    final photo = (data['photoUrl'] as String?)?.trim() ?? '';

    if (name.isNotEmpty &&
        username.isNotEmpty &&
        bio.isNotEmpty &&
        photo.isNotEmpty) {
      await unlockBadgeIfMissing(uid, BadgeId.profileComplete);
    }
  }

  /// Call on app launch / session start. Computes streak and awards badge at 3.
  ///
  /// Writes two fields on the user doc:
  /// - `lastActiveDate` — ISO date string `yyyy-MM-dd`
  /// - `currentStreak`  — int, consecutive days
  static Future<void> onSessionStart(String uid) async {
    final userRef = FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(uid);
    final snap = await userRef.get();
    final data = snap.data() ?? {};

    final now = DateTime.now();
    final todayStr = _dateKey(now);
    final lastStr = data['lastActiveDate'] as String?;
    final oldStreak = (data['currentStreak'] as num?)?.toInt() ?? 0;

    if (lastStr == todayStr) return; // already counted today

    final yesterday = _dateKey(now.subtract(const Duration(days: 1)));
    final newStreak = (lastStr == yesterday) ? oldStreak + 1 : 1;

    await userRef.update({
      'lastActiveDate': todayStr,
      'currentStreak': newStreak,
    });

    if (newStreak >= 3) {
      await unlockBadgeIfMissing(uid, BadgeId.threeDayStreak);
    }
  }

  /// Call after a like is added. Checks whether the letter author's letter
  /// has reached 10 likes.
  static Future<void> afterLetterLiked({
    required String letterDocId,
  }) async {
    final letterSnap = await FirebaseFirestore.instance
        .collection(FirestoreCollections.letters)
        .doc(letterDocId)
        .get();
    final letterData = letterSnap.data();
    if (letterData == null) return;

    final likeCount = (letterData['likeCount'] as num?)?.toInt() ?? 0;
    final authorUid = letterData['senderUid'] as String?;
    if (authorUid == null || authorUid.isEmpty) return;

    if (likeCount >= 10) {
      await unlockBadgeIfMissing(authorUid, BadgeId.letterLikedByTen);
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
