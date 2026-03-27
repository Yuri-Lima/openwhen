import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/firestore_collections.dart';

/// Upload de foto de perfil para Firebase Storage e atualização do campo `photoUrl` em Firestore.
class AvatarService {
  AvatarService._();

  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Envia a imagem para `avatars/{uid}.jpg` e retorna a URL de download.
  static Future<String> uploadAvatar(String uid, XFile image) async {
    final bytes = await image.readAsBytes();
    const maxBytes = 5 * 1024 * 1024;
    if (bytes.length > maxBytes) {
      throw Exception('Imagem muito grande (máx. 5 MB)');
    }
    final ref = _storage.ref().child('avatars/$uid.jpg');
    await ref.putData(
      bytes,
      SettableMetadata(contentType: 'image/jpeg', cacheControl: 'public, max-age=31536000'),
    );
    return ref.getDownloadURL();
  }

  static Future<void> updateUserPhotoUrl(String uid, String url) async {
    await FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(uid).update({
      'photoUrl': url,
    });
  }

  static Future<void> removeUserPhotoUrl(String uid) async {
    await FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(uid).update({
      'photoUrl': null,
    });
    try {
      await _storage.ref().child('avatars/$uid.jpg').delete();
    } catch (_) {
      // Objeto pode não existir
    }
  }
}
