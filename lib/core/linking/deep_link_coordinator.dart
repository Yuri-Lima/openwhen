import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/firestore_collections.dart';
import '../letters/external_letters_service.dart';
import '../navigation/app_navigator_key.dart';
import 'pending_deep_link.dart';
import '../../features/capsules/presentation/screens/capsule_detail_screen.dart';
import '../../features/letters/presentation/screens/letter_detail_screen.dart';

/// After sign-in, claims external letters and opens a pending universal-link target.
class DeepLinkCoordinator {
  DeepLinkCoordinator._();

  /// Call when the home shell is ready and user is signed in.
  static Future<void> handlePendingAfterSignIn(BuildContext context) async {
    await ExternalLettersService.claimExternalLetters();
    if (!context.mounted) return;

    final letterId = PendingDeepLink.pendingLetterId;
    final capsuleId = PendingDeepLink.pendingCapsuleId;
    if (letterId != null) {
      if (await _openLetter(letterId)) {
        PendingDeepLink.pendingLetterId = null;
      }
      return;
    }
    if (capsuleId != null) {
      if (await _openCapsule(capsuleId)) {
        PendingDeepLink.pendingCapsuleId = null;
      }
    }
  }

  static Future<bool> _openLetter(String docId) async {
    final snap = await FirebaseFirestore.instance
        .collection(FirestoreCollections.letters)
        .doc(docId)
        .get();
    if (!snap.exists) return false;
    final data = snap.data();
    if (data == null) return false;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;
    final receiverOk = data['receiverUid'] == uid;
    final senderOk = data['senderUid'] == uid;
    final publicOk = data['isPublic'] == true && data['status'] == 'opened';
    if (!receiverOk && !senderOk && !publicOk) {
      return false;
    }
    final nav = rootNavigatorKey.currentState;
    if (nav == null) return false;
    nav.push(
      MaterialPageRoute<void>(
        builder: (_) => LetterDetailScreen(
          data: Map<String, dynamic>.from(data),
          docId: docId,
        ),
      ),
    );
    return true;
  }

  static Future<bool> _openCapsule(String docId) async {
    final snap = await FirebaseFirestore.instance
        .collection(FirestoreCollections.capsules)
        .doc(docId)
        .get();
    if (!snap.exists) return false;
    final data = snap.data();
    if (data == null) return false;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;
    final senderOk = data['senderUid'] == uid;
    final receiverOk = data['receiverUid'] == uid;
    final part = data['participantUids'];
    final inParticipants =
        part is List && part.map((e) => e.toString()).contains(uid);
    final publicOk = data['isPublic'] == true && data['status'] == 'opened';
    if (!senderOk && !receiverOk && !inParticipants && !publicOk) {
      return false;
    }
    final nav = rootNavigatorKey.currentState;
    if (nav == null) return false;
    nav.push(
      MaterialPageRoute<void>(
        builder: (_) => CapsuleDetailScreen(
          data: Map<String, dynamic>.from(data),
          docId: docId,
        ),
      ),
    );
    return true;
  }
}
