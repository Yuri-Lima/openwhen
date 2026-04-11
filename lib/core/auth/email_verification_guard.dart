import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../../shared/widgets/email_verification_sheet.dart';

/// Returns `true` if the current user has a verified email address.
///
/// On first call it tries a silent [User.reload] so that users who just
/// clicked the verification link get through without seeing any dialog.
/// If the email is still unverified it presents [showEmailVerificationSheet].
Future<bool> requireVerifiedEmail(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return false;
  if (user.emailVerified) return true;

  try {
    await user.reload();
  } catch (_) {}
  final refreshed = FirebaseAuth.instance.currentUser;
  if (refreshed?.emailVerified == true) return true;

  if (!context.mounted) return false;
  final result = await showEmailVerificationSheet(context);
  return result == true;
}
