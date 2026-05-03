import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../billing/subscription_tier.dart';
import '../constants/firestore_collections.dart';
import '../policy/policy_constants.dart';
import '../user_search/user_search_tokens.dart';

/// Garante que `users/{uid}` existe com os campos exigidos pelas [Firestore security rules]
/// para `create`. Sem isto, um `set(merge: true)` que só adiciona `fcmToken` tenta um **create**
/// inválido e devolve `permission-denied`.
///
/// Se o documento não existir, cria com todos os campos obrigatórios.
/// Para [dateOfBirth], usa uma data placeholder (1900-01-01) e marca
/// [profileIncomplete] = true para que a UI peça ao utilizador para
/// completar o perfil na próxima sessão.
Future<void> ensureUserFirestoreProfileExists(firebase_auth.User user) async {
  final ref =
      FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(user.uid);
  final snap = await ref.get();
  if (snap.exists) return;

  final email = user.email ?? '';
  // Generate a username that always passes Firestore rules (3–20 chars, [a-z0-9._]).
  // Email prefix may be too short, contain invalid chars, or be empty.
  String rawPrefix = email.isNotEmpty
      ? email.split('@').first.toLowerCase().replaceAll(RegExp(r'[^a-z0-9._]'), '')
      : '';
  // Strip leading/trailing dots/underscores and consecutive dots.
  rawPrefix = rawPrefix
      .replaceAll(RegExp(r'^[._]+|[._]+$'), '')
      .replaceAll(RegExp(r'\.{2,}'), '.');
  // Ensure minimum 3 chars — pad with uid fragment if needed.
  if (rawPrefix.length < 3) {
    rawPrefix = 'user.${user.uid.substring(0, 6).toLowerCase()}';
  }
  // Ensure max 20 chars.
  final username = rawPrefix.length > 20 ? rawPrefix.substring(0, 20) : rawPrefix;
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
    // Campos obrigatórios adicionados para conformidade com Firestore rules.
    // dateOfBirth placeholder — UI deve detectar profileIncomplete e pedir
    // ao utilizador para completar o perfil.
    'dateOfBirth': Timestamp.fromDate(DateTime(1900, 1, 1)),
    'acceptedTermsVersion': kCurrentTermsVersion,
    'acceptedPrivacyVersion': kCurrentPrivacyVersion,
    'termsAcceptedAt': FieldValue.serverTimestamp(),
    'profileIncomplete': true,
  });
}
