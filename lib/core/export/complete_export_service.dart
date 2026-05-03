import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../constants/firestore_collections.dart';
import '../../shared/utils/storage_export_url.dart';
import '../../shared/utils/voice_url.dart';

/// Batch size for paginated Firestore queries.
const _batchSize = 500;

/// Result of a complete data export, with counts for audit logging.
class ExportResult {
  final int profileCount;
  final int lettersCount;
  final int capsulesCount;
  final int commentsCount;
  final int likesCount;
  final int followersCount;
  final int followingCount;
  final int blocksCount;
  final int badgesCount;
  final int mediaFilesCount;

  const ExportResult({
    this.profileCount = 1,
    this.lettersCount = 0,
    this.capsulesCount = 0,
    this.commentsCount = 0,
    this.likesCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.blocksCount = 0,
    this.badgesCount = 0,
    this.mediaFilesCount = 0,
  });

  int get totalItems =>
      profileCount +
      lettersCount +
      capsulesCount +
      commentsCount +
      likesCount +
      followersCount +
      followingCount +
      blocksCount +
      badgesCount;

  Map<String, int> toMetadata() => {
        'profileCount': profileCount,
        'lettersCount': lettersCount,
        'capsulesCount': capsulesCount,
        'commentsCount': commentsCount,
        'likesCount': likesCount,
        'followersCount': followersCount,
        'followingCount': followingCount,
        'blocksCount': blocksCount,
        'badgesCount': badgesCount,
        'mediaFilesCount': mediaFilesCount,
      };
}

/// Callback for progress updates during export.
typedef ExportProgressCallback = void Function(String stage, double progress);

/// Fetches all user data and builds a ZIP with JSON files + media.
///
/// ZIP structure:
/// ```
/// whenote_export_<timestamp>/
///   profile.json
///   letters.json
///   capsules.json
///   comments.json
///   likes.json
///   follows.json
///   blocks.json
///   badges.json
///   media/
///     <letterId>_voice.m4a
///     <letterId>_handwritten.jpg
///     capsules/<capsuleId>_photo_0.jpg
/// ```
Future<({File zipFile, ExportResult result})> buildCompleteExportZip({
  required FirebaseFirestore firestore,
  required String uid,
  ExportProgressCallback? onProgress,
}) async {
  final archive = Archive();
  final prefix = 'whenote_export_${DateTime.now().millisecondsSinceEpoch}';
  var mediaCount = 0;

  // --- 1. Profile ---
  onProgress?.call('profile', 0.05);
  final userSnap = await firestore.collection(FirestoreCollections.users).doc(uid).get();
  final profileData = _sanitizeProfile(userSnap.data() ?? {});
  _addJsonFile(archive, '$prefix/profile.json', {
    'exportDate': DateTime.now().toIso8601String(),
    'exportFormat': 'whenote-sar-v1',
    'profile': profileData,
  });

  // --- 2. Letters ---
  onProgress?.call('letters', 0.15);
  final letterDocs = await _fetchLetters(firestore, uid);
  final lettersJson = letterDocs.map((d) => _sanitizeLetter(d.id, d.data()!)).toList();
  _addJsonFile(archive, '$prefix/letters.json', {
    'count': lettersJson.length,
    'letters': lettersJson,
  });

  // --- 3. Letter media ---
  onProgress?.call('media', 0.30);
  for (final doc in letterDocs) {
    final m = doc.data()!;
    final id = _safeId(doc.id);

    final voiceBytes = await _fetchMediaIfAllowed(m['voiceUrl'] as String?, isValidVoiceLetterUrl);
    if (voiceBytes != null) {
      archive.addFile(ArchiveFile('$prefix/media/${id}_voice.m4a', voiceBytes.length, voiceBytes));
      mediaCount++;
    }

    final hwBytes = await _fetchMediaIfAllowed(m['handwrittenImageUrl'] as String?, isValidHandwrittenExportUrl);
    if (hwBytes != null) {
      archive.addFile(ArchiveFile('$prefix/media/${id}_handwritten.jpg', hwBytes.length, hwBytes));
      mediaCount++;
    }
  }

  // --- 4. Capsules (sent + received/participated) ---
  onProgress?.call('capsules', 0.45);
  final capsuleDocs = await _fetchCapsules(firestore, uid);
  final capsulesJson = capsuleDocs.map((d) => _sanitizeCapsule(d.id, d.data()!)).toList();
  _addJsonFile(archive, '$prefix/capsules.json', {
    'count': capsulesJson.length,
    'capsules': capsulesJson,
  });

  // Capsule photos
  for (final doc in capsuleDocs) {
    final m = doc.data()!;
    final photos = (m['photos'] as List<dynamic>?) ?? [];
    final id = _safeId(doc.id);
    for (var i = 0; i < photos.length; i++) {
      final url = photos[i] as String?;
      if (url == null) continue;
      final bytes = await _fetchMediaIfAllowed(url, _isValidCapsulePhotoUrl);
      if (bytes != null) {
        archive.addFile(ArchiveFile('$prefix/media/capsules/${id}_photo_$i.jpg', bytes.length, bytes));
        mediaCount++;
      }
    }
  }

  // --- 5. Comments ---
  onProgress?.call('comments', 0.55);
  final commentDocs = await _fetchCollection(
    firestore.collection(FirestoreCollections.comments).where('userUid', isEqualTo: uid),
  );
  final commentsJson = commentDocs.map((d) => _sanitizeComment(d.id, d.data()!)).toList();
  _addJsonFile(archive, '$prefix/comments.json', {
    'count': commentsJson.length,
    'comments': commentsJson,
  });

  // --- 6. Likes ---
  onProgress?.call('likes', 0.65);
  final likeDocs = await _fetchCollection(
    firestore.collection(FirestoreCollections.likes).where('userUid', isEqualTo: uid),
  );
  final likesJson = likeDocs.map((d) => _sanitizeLike(d.id, d.data()!)).toList();
  _addJsonFile(archive, '$prefix/likes.json', {
    'count': likesJson.length,
    'likes': likesJson,
  });

  // --- 7. Follows (followers + following) ---
  onProgress?.call('follows', 0.75);
  final followerDocs = await _fetchCollection(
    firestore.collection(FirestoreCollections.follows).where('followingUid', isEqualTo: uid),
  );
  final followingDocs = await _fetchCollection(
    firestore.collection(FirestoreCollections.follows).where('followerUid', isEqualTo: uid),
  );
  _addJsonFile(archive, '$prefix/follows.json', {
    'followers': {
      'count': followerDocs.length,
      'items': followerDocs.map((d) => _sanitizeFollow(d.id, d.data()!)).toList(),
    },
    'following': {
      'count': followingDocs.length,
      'items': followingDocs.map((d) => _sanitizeFollow(d.id, d.data()!)).toList(),
    },
  });

  // --- 8. Blocks ---
  onProgress?.call('blocks', 0.80);
  final blockDocs = await _fetchCollection(
    firestore.collection(FirestoreCollections.blocks).where('blockedBy', isEqualTo: uid),
  );
  final blocksJson = blockDocs.map((d) {
    final data = d.data()!;
    return {
      'id': d.id,
      'blockedUid': data['blockedUid'],
      'createdAt': _tsToIso(data['createdAt']),
    };
  }).toList();
  _addJsonFile(archive, '$prefix/blocks.json', {
    'count': blocksJson.length,
    'blocks': blocksJson,
  });

  // --- 9. Badges ---
  onProgress?.call('badges', 0.85);
  final badgeDocs = await firestore.collection('users/$uid/badgeUnlocks').get();
  final badgesJson = badgeDocs.docs.map((d) {
    final data = d.data();
    return {
      'badgeId': d.id,
      'unlockedAt': _tsToIso(data['unlockedAt']),
    };
  }).toList();
  _addJsonFile(archive, '$prefix/badges.json', {
    'count': badgesJson.length,
    'badges': badgesJson,
  });

  // --- Encode ZIP ---
  onProgress?.call('zip', 0.95);
  final zipBytes = ZipEncoder().encodeBytes(archive);
  final dir = await getTemporaryDirectory();
  final zipFile = File(p.join(dir.path, '$prefix.zip'));
  await zipFile.writeAsBytes(zipBytes, flush: true);

  onProgress?.call('done', 1.0);

  return (
    zipFile: zipFile,
    result: ExportResult(
      lettersCount: lettersJson.length,
      capsulesCount: capsulesJson.length,
      commentsCount: commentsJson.length,
      likesCount: likesJson.length,
      followersCount: followerDocs.length,
      followingCount: followingDocs.length,
      blocksCount: blockDocs.length,
      badgesCount: badgesJson.length,
      mediaFilesCount: mediaCount,
    ),
  );
}

/// Share the ZIP file via system share sheet.
Future<void> shareCompleteExportZip(File zipFile) async {
  await Share.shareXFiles([XFile(zipFile.path)]);
  await _deleteQuietly(zipFile);
}

// ─── Fetch helpers ──────────────────────────────────────────────────────────

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _fetchLetters(
  FirebaseFirestore firestore,
  String uid,
) async {
  final byId = <String, QueryDocumentSnapshot<Map<String, dynamic>>>{};

  await _fetchAllBatched(
    query: firestore
        .collection(FirestoreCollections.letters)
        .where('senderUid', isEqualTo: uid)
        .orderBy(FieldPath.documentId),
    into: byId,
  );

  await _fetchAllBatched(
    query: firestore
        .collection(FirestoreCollections.letters)
        .where('receiverUid', isEqualTo: uid)
        .orderBy(FieldPath.documentId),
    into: byId,
  );

  return byId.values.toList();
}

/// Fetches all capsules the user created OR participates in, deduplicated.
Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _fetchCapsules(
  FirebaseFirestore firestore,
  String uid,
) async {
  final byId = <String, QueryDocumentSnapshot<Map<String, dynamic>>>{};

  // Capsules the user created
  await _fetchAllBatched(
    query: firestore
        .collection(FirestoreCollections.capsules)
        .where('senderUid', isEqualTo: uid)
        .orderBy(FieldPath.documentId),
    into: byId,
  );

  // Capsules the user participates in (received / collective)
  await _fetchAllBatched(
    query: firestore
        .collection(FirestoreCollections.capsules)
        .where('participantUids', arrayContains: uid)
        .orderBy(FieldPath.documentId),
    into: byId,
  );

  return byId.values.toList();
}

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _fetchCollection(
  Query<Map<String, dynamic>> baseQuery,
) async {
  final byId = <String, QueryDocumentSnapshot<Map<String, dynamic>>>{};
  await _fetchAllBatched(
    query: baseQuery.orderBy(FieldPath.documentId),
    into: byId,
  );
  return byId.values.toList();
}

Future<void> _fetchAllBatched({
  required Query<Map<String, dynamic>> query,
  required Map<String, QueryDocumentSnapshot<Map<String, dynamic>>> into,
}) async {
  DocumentSnapshot? lastDoc;
  while (true) {
    var page = query.limit(_batchSize);
    if (lastDoc != null) page = page.startAfterDocument(lastDoc);
    final snap = await page.get();
    for (final d in snap.docs) {
      into[d.id] = d;
    }
    if (snap.docs.length < _batchSize) break;
    lastDoc = snap.docs.last;
  }
}

// ─── Sanitization (strip internal fields, convert Timestamps) ───────────────

Map<String, dynamic> _sanitizeProfile(Map<String, dynamic> raw) {
  return {
    'name': raw['name'],
    'username': raw['username'],
    'email': raw['email'],
    'bio': raw['bio'],
    'photoUrl': raw['photoUrl'],
    'language': raw['language'],
    'country': raw['country'],
    'createdAt': _tsToIso(raw['createdAt']),
    'dateOfBirth': _tsToIso(raw['dateOfBirth']),
    'subscriptionTier': raw['subscriptionTier'],
    'accountStatus': raw['accountStatus'],
    'analyticsConsent': raw['analyticsConsent'],
    'analyticsConsentDate': _tsToIso(raw['analyticsConsentDate']),
    'lettersSentCount': raw['lettersSentCount'],
    'lettersReceivedCount': raw['lettersReceivedCount'],
    'lockedLettersCount': raw['lockedLettersCount'],
    'openedLettersCount': raw['openedLettersCount'],
  };
}

Map<String, dynamic> _sanitizeLetter(String id, Map<String, dynamic> raw) {
  return {
    'id': id,
    'title': raw['title'],
    'message': raw['message'],
    'senderName': raw['senderName'],
    'receiverName': raw['receiverName'],
    'status': raw['status'],
    'isPublic': raw['isPublic'],
    'createdAt': _tsToIso(raw['createdAt']),
    'openDate': _tsToIso(raw['openDate']),
    'openedAt': _tsToIso(raw['openedAt']),
    'publishedAt': _tsToIso(raw['publishedAt']),
    'musicUrl': raw['musicUrl'],
    'likeCount': raw['likeCount'],
    'commentCount': raw['commentCount'],
    if (raw['senderLocation'] != null) ...{
      'hasLocation': true,
      'senderLocation': _geoPointToMap(raw['senderLocation']),
    },
  };
}

Map<String, dynamic> _sanitizeCapsule(String id, Map<String, dynamic> raw) {
  return {
    'id': id,
    'title': raw['title'],
    'message': raw['message'],
    'theme': raw['theme'],
    'senderName': raw['senderName'],
    'receiverName': raw['receiverName'],
    'isCollective': raw['isCollective'],
    'status': raw['status'],
    'isPublic': raw['isPublic'],
    'openDate': _tsToIso(raw['openDate']),
    'openEvent': raw['openEvent'],
    'openEventType': raw['openEventType'],
    'createdAt': _tsToIso(raw['createdAt']),
    'openedAt': _tsToIso(raw['openedAt']),
    'publishedAt': _tsToIso(raw['publishedAt']),
    'musicUrl': raw['musicUrl'],
    'photoCount': (raw['photos'] as List?)?.length ?? 0,
    'likeCount': raw['likeCount'],
    'commentCount': raw['commentCount'],
  };
}

Map<String, dynamic> _sanitizeComment(String id, Map<String, dynamic> raw) {
  return {
    'id': id,
    'letterId': raw['letterId'],
    'message': raw['message'],
    'createdAt': _tsToIso(raw['createdAt']),
  };
}

Map<String, dynamic> _sanitizeLike(String id, Map<String, dynamic> raw) {
  return {
    'id': id,
    'letterId': raw['letterId'],
    'createdAt': _tsToIso(raw['createdAt']),
  };
}

Map<String, dynamic> _sanitizeFollow(String id, Map<String, dynamic> raw) {
  return {
    'id': id,
    'followerUid': raw['followerUid'],
    'followingUid': raw['followingUid'],
    'createdAt': _tsToIso(raw['createdAt']),
  };
}

// ─── Utilities ──────────────────────────────────────────────────────────────

void _addJsonFile(Archive archive, String path, Map<String, dynamic> data) {
  final bytes = utf8.encode(const JsonEncoder.withIndent('  ').convert(data));
  archive.addFile(ArchiveFile(path, bytes.length, bytes));
}

String? _tsToIso(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate().toIso8601String();
  if (value is DateTime) return value.toIso8601String();
  return value.toString();
}

Map<String, double>? _geoPointToMap(dynamic value) {
  if (value == null) return null;
  if (value is GeoPoint) {
    return {'latitude': value.latitude, 'longitude': value.longitude};
  }
  if (value is Map) {
    final lat = value['latitude'] ?? value['lat'];
    final lng = value['longitude'] ?? value['lng'];
    if (lat is num && lng is num) {
      return {'latitude': lat.toDouble(), 'longitude': lng.toDouble()};
    }
  }
  return null;
}

String _safeId(String id) {
  final b = StringBuffer();
  for (final c in id.runes) {
    final ch = String.fromCharCode(c);
    if (RegExp(r'[a-zA-Z0-9_-]').hasMatch(ch)) b.write(ch);
  }
  final s = b.toString();
  return s.isEmpty ? 'item' : s.substring(0, s.length > 32 ? 32 : s.length);
}

Future<Uint8List?> _fetchMediaIfAllowed(String? url, bool Function(String?) allow) async {
  if (url == null || !allow(url)) return null;
  try {
    final r = await http.get(Uri.parse(url));
    if (r.statusCode != 200) return null;
    return r.bodyBytes;
  } catch (_) {
    return null;
  }
}

bool _isValidCapsulePhotoUrl(String? raw) =>
    isValidFirebaseStorageExportUrl(raw, pathSegment: 'capsules');

Future<void> _deleteQuietly(File? file) async {
  if (file == null) return;
  try {
    if (await file.exists()) await file.delete();
  } catch (_) {
    if (kDebugMode) debugPrint('export: temp delete failed');
  }
}
