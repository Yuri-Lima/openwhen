import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../billing/firebase_functions_region.dart';
import '../services/analytics_service.dart';

/// Calls [claimExternalLetters] to attach no-account letters to the signed-in user.
class ExternalLettersService {
  ExternalLettersService._();

  static final FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: kFirebaseFunctionsRegion);

  /// Returns number of letters claimed, or 0 if skipped or on error.
  static Future<int> claimExternalLetters() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;
    if (user.email == null || user.email!.trim().isEmpty) return 0;
    if (!user.emailVerified) return 0;

    try {
      final result = await _functions.httpsCallable('claimExternalLetters').call();
      final map = result.data;
      if (map is! Map) return 0;
      final claimed = (map['claimed'] as num?)?.toInt() ?? 0;
      if (claimed > 0) {
        await AnalyticsService.logExternalLettersClaimed(claimed);
      }
      return claimed;
    } catch (e, st) {
      final msg = e.toString();
      if (msg.contains('email_not_verified') || msg.contains('email_required')) {
        return 0;
      }
      if (kDebugMode) {
        debugPrint('[ExternalLetters] claim error: $e\n$st');
      }
      return 0;
    }
  }
}
