import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../../../shared/utils/voice_url.dart';

Future<String?> uploadVoiceLetterFile(String localPath, String uid) async {
  final file = File(localPath);
  if (!await file.exists()) return null;
  final ref = FirebaseStorage.instance.ref(
    'voiceLetters/${uid}_${DateTime.now().millisecondsSinceEpoch}.m4a',
  );
  await ref.putFile(file, SettableMetadata(contentType: 'audio/mp4'));
  final url = await ref.getDownloadURL();
  if (!isValidVoiceLetterUrl(url)) return null;
  try {
    await file.delete();
  } catch (_) {}
  return url;
}

Future<void> deleteVoiceFile(String? path) async {
  if (path == null) return;
  try {
    final f = File(path);
    if (await f.exists()) await f.delete();
  } catch (_) {}
}
