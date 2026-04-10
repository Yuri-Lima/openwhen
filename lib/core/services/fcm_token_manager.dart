import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../constants/firestore_collections.dart';
import 'ensure_user_firestore_profile.dart';

/// Persiste o token FCM no documento do usuário (um dispositivo por vez no MVP).
class FcmTokenManager {
  FcmTokenManager._();

  static Future<void> saveToken(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await ensureUserFirestoreProfileExists(user);
      await FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(user.uid).set(
            {
              'fcmToken': token,
              'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        if (kDebugMode) {
          debugPrint('FcmTokenManager.saveToken permission-denied (rules or project): $e');
        }
        return;
      }
      rethrow;
    }
  }

  static Future<void> clearToken() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      await FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(uid).update({
        'fcmToken': FieldValue.delete(),
        'fcmTokenUpdatedAt': FieldValue.delete(),
      });
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied' && kDebugMode) {
        debugPrint('FcmTokenManager.clearToken permission-denied: $e');
      }
    }
  }
}
