import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;

import '../constants/firestore_collections.dart';
import 'user_search_result.dart';

/// Scalable user search: username prefix + optional `searchTokens` (name words).
/// Does not use or return email.
class UserSearchService {
  UserSearchService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _db = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  static const int minQueryLength = 2;
  static const int maxResults = 30;

  static const String _fieldUsername = 'username';
  static const String _fieldSearchTokens = 'searchTokens';

  /// Normalizes query: trim, lower, strip leading @.
  static String normalizeQuery(String raw) {
    var q = raw.trim().toLowerCase();
    if (q.startsWith('@')) q = q.substring(1);
    return q;
  }

  UserSearchResult _fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final display =
        (data['displayName'] ?? data['name'] ?? '') as String? ?? '';
    final name = (data['name'] ?? '') as String? ?? '';
    final public = display.isNotEmpty ? display : name;
    return UserSearchResult(
      uid: doc.id,
      username: (data['username'] ?? '') as String? ?? '',
      publicName: public,
      photoUrl: data['photoUrl'] as String?,
    );
  }

  /// Returns users matching [rawQuery] by username prefix and/or name tokens.
  /// Excludes current user and any uid in [excludeUids].
  Future<List<UserSearchResult>> search(
    String rawQuery, {
    Set<String>? excludeUids,
  }) async {
    final q = normalizeQuery(rawQuery);
    if (q.length < minQueryLength) return [];

    final self = _auth.currentUser?.uid;
    final exclude = <String>{?self, ...?excludeUids};

    final users = _db.collection(FirestoreCollections.users);
    final byUid = <String, _ScoredDoc>{};

    // 1) Username prefix (indexed range).
    try {
      final snap = await users
          .where(_fieldUsername, isGreaterThanOrEqualTo: q)
          .where(_fieldUsername, isLessThan: '$q\uf8ff')
          .limit(maxResults)
          .get();
      for (final doc in snap.docs) {
        if (exclude.contains(doc.id)) continue;
        byUid[doc.id] = _ScoredDoc(doc, 0);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[UserSearch] username prefix query error: $e');
    }

    // 2) Public name tokens (array-contains on full query string as token).
    if (byUid.length < maxResults) {
      try {
        final snap = await users
            .where(_fieldSearchTokens, arrayContains: q)
            .limit(maxResults)
            .get();
        for (final doc in snap.docs) {
          if (exclude.contains(doc.id)) continue;
          byUid.putIfAbsent(doc.id, () => _ScoredDoc(doc, 1));
        }
      } catch (e) {
        if (kDebugMode) debugPrint('[UserSearch] searchTokens query error: $e');
      }
    }

    final merged = byUid.values.toList()
      ..sort((a, b) {
        final c = a.score.compareTo(b.score);
        if (c != 0) return c;
        return a.doc.id.compareTo(b.doc.id);
      });

    final results = <UserSearchResult>[];
    for (final s in merged) {
      results.add(_fromDoc(s.doc));
      if (results.length >= maxResults) break;
    }
    return results;
  }
}

class _ScoredDoc {
  _ScoredDoc(this.doc, this.score);
  final DocumentSnapshot doc;
  final int score;
}
