import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/firestore_collections.dart';
import '../../gamification/badge_unlock_service.dart';

Future<void> setLetterPublic({
  required String docId,
  required bool isPublic,
}) async {
  await FirebaseFirestore.instance
      .collection(FirestoreCollections.letters)
      .doc(docId)
      .update({
    'isPublic': isPublic,
    'publishedAt': isPublic ? FieldValue.serverTimestamp() : null,
  });
  if (isPublic) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await BadgeUnlockHooks.afterLetterMadePublic(uid);
    }
  }
}

Future<void> setLetterHideReceiverName({
  required String docId,
  required bool hide,
}) async {
  await FirebaseFirestore.instance
      .collection(FirestoreCollections.letters)
      .doc(docId)
      .update({'hideReceiverName': hide});
}

/// Usado no feed pelo destinatário para ocultar o nome de quem enviou a carta.
Future<void> setLetterHideSenderName({
  required String docId,
  required bool hide,
}) async {
  await FirebaseFirestore.instance
      .collection(FirestoreCollections.letters)
      .doc(docId)
      .update({'hideSenderName': hide});
}

Future<void> deleteLetterDocument(String docId) async {
  await FirebaseFirestore.instance
      .collection(FirestoreCollections.letters)
      .doc(docId)
      .delete();
}
