import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants/firestore_collections.dart';
import '../letters/external_letters_service.dart';
import '../navigation/app_navigator_key.dart';
import 'pending_deep_link.dart';
import 'share_link_service.dart';
import '../../features/capsules/presentation/screens/capsule_detail_screen.dart';
import '../../features/letters/presentation/screens/letter_detail_screen.dart';

/// After sign-in, claims external letters and opens a pending universal-link target.
class DeepLinkCoordinator {
  DeepLinkCoordinator._();

  /// Call when the home shell is ready and user is signed in.
  static Future<void> handlePendingAfterSignIn(BuildContext context) async {
    final letterId = PendingDeepLink.pendingLetterId;
    final capsuleId = PendingDeepLink.pendingCapsuleId;
    final shareToken = PendingDeepLink.pendingShareToken;

    // Only call the callable when there is actually a pending deep link.
    // Calling HTTPSCallable immediately at startup can crash the native
    // Firebase iOS SDK (SIGABRT in Swift async task dealloc — see
    // TROUBLESHOOTING.md §2). When needed, delay briefly so the Flutter
    // engine / native SDK is fully settled before the network call.
    if (letterId != null || capsuleId != null || shareToken != null) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await ExternalLettersService.claimExternalLetters();
      if (!context.mounted) return;
    }

    // Handle share link claim (takes priority — the user explicitly clicked a share link)
    if (shareToken != null) {
      final claimedLetterId = await _claimShareLink(shareToken);
      PendingDeepLink.pendingShareToken = null;
      if (claimedLetterId != null && context.mounted) {
        await _openLetter(claimedLetterId);
      }
      return;
    }

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

  /// Claims a shared letter via its share token.
  /// Returns the letterId on success, or null on failure.
  static Future<String?> _claimShareLink(String shareToken) async {
    try {
      return await ShareLinkService.claimShareLink(shareToken);
    } catch (e) {
      debugPrint('[DeepLink] claimShareLink failed: $e');
      return null;
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
