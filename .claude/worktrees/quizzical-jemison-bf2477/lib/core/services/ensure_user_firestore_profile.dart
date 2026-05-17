import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../billing/subscription_tier.dart';
import '../constants/firestore_collections.dart';
import '../user_search/user_search_tokens.dart';

/// Garante que `users/{uid}` existe com os campos exigidos pelas [Firestore security rules]
/// para `create`. Sem isto, um `set(merge: true)` que só adiciona `fcmToken` tenta um **create**
/// inválido e devolve `permission-denied`.
Future<void> ensureUserFirestoreProfileExists(firebase_auth.User user) async {
  final ref =
      FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(user.uid);
  final snap = await ref.get();
  if (snap.exists) return;

  final email = user.email ?? '';
  final username = email.isNotEmpty
      ? email.split('@').first.toLowerCase()
      : 'user_${user.uid.substring(0, 8)}';
  final name = (user.displayName != null && user.displayName!.trim().isNotEmpty)
      ? user.displayName!.trim()
      : username;

  final searchTokens = buildUserSearchTokens(
    username: username,
    displayName: name,
    name: name,
  );

  await ref.set({
    'uid': user.uid,
    'name': name,
    'displayName': name,
    'username': username,
    'searchTokens': searchTokens,
    'email': email.isEmpty ? null : email,
    'photoUrl': user.photoURL,
    'bio': null,
    'isPrivate': false,
    'createdAt': FieldValue.serverTimestamp(),
    'lettersSentCount': 0,
    'lettersReceivedCount': 0,
    'lockedLettersCount': 0,
    'openedLettersCount': 0,
    'followersCount': 0,
    'followingCount': 0,
    'lettersCount': 0,
    'language': 'pt-BR',
    'preferredLanguage': 'pt',
    'country': null,
    'subscriptionTier': subscriptionTierId(SubscriptionTier.free),
  });
}
