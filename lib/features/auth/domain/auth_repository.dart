import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/auth_service.dart';
import '../models/app_user.dart';
import '../../../core/constants/firestore_collections.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  User? get currentUser => _authService.currentUser;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _authService.registerWithEmail(
      email: email,
      password: password,
    );

    final user = credential.user!;
    final username = email.split('@')[0];

    await _firestore
        .collection(FirestoreCollections.users)
        .doc(user.uid)
        .set({
      'uid': user.uid,
      'name': name,
      'username': username,
      'email': email,
      'photoUrl': null,
      'bio': null,
      'createdAt': Timestamp.now(),
      'lettersSentCount': 0,
      'lettersReceivedCount': 0,
      'lockedLettersCount': 0,
      'openedLettersCount': 0,
      'language': 'pt-BR',
      'country': null,
    });
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _authService.loginWithEmail(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _firestore
        .collection(FirestoreCollections.users)
        .doc(uid)
        .get();

    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }
}
