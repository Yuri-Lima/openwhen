import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String username,
    required DateTime dateOfBirth,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.register(
          name: name,
          email: email,
          password: password,
          username: username,
          dateOfBirth: dateOfBirth,
        ));
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.login(
          email: email,
          password: password,
        ));
  }

  /// Returns `true` when the user is new and needs age-gate + terms.
  Future<bool> signInWithApple() async {
    state = const AsyncValue.loading();
    bool isNew = false;
    state = await AsyncValue.guard(() async {
      isNew = await _repository.signInWithApple();
    });
    return isNew;
  }

  /// Returns `true` when the user is new and needs age-gate + terms.
  Future<bool> signInWithGoogle() async {
    state = const AsyncValue.loading();
    bool isNew = false;
    state = await AsyncValue.guard(() async {
      isNew = await _repository.signInWithGoogle();
    });
    return isNew;
  }

  /// Completes registration for a new OAuth user (creates Firestore doc).
  Future<void> completeOAuthRegistration({required DateTime dateOfBirth}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.completeOAuthRegistration(dateOfBirth: dateOfBirth),
    );
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.signOut());
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
