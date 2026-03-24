import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/firestore_collections.dart';

/// Persiste o token FCM no documento do usuário (um dispositivo por vez no MVP).
class FcmTokenManager {
  FcmTokenManager._();

  static Future<void> saveToken(String token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(uid).set(
      {
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  static Future<void> clearToken() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(uid).update({
      'fcmToken': FieldValue.delete(),
      'fcmTokenUpdatedAt': FieldValue.delete(),
    });
  }
}
