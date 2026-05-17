import 'package:firebase_auth/firebase_auth.dart';

/// `admin: true` custom claim set by Cloud Function [bootstrapAdminClaim].
Future<bool> currentUserHasAdminClaim() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return false;
  final r = await user.getIdTokenResult(true);
  return r.claims?['admin'] == true;
}
