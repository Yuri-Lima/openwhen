import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_collections.dart';

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
