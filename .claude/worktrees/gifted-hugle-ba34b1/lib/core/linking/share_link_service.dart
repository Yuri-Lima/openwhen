import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

/// Service for generating, claiming, and revoking share links for letters.
///
/// All operations call Firebase Cloud Functions (Admin SDK) since
/// the share-related fields are protected by Firestore rules.
class ShareLinkService {
  ShareLinkService._();

  static final _functions = FirebaseFunctions.instanceFor(region: 'us-central1');

  /// Generates a shareable link for a letter.
  /// Returns the full URL (e.g. https://whenote.app/open/{token}).
  /// Idempotent: returns the existing link if already generated.
  static Future<String?> generateShareLink(String letterId) async {
    try {
      final result = await _functions
          .httpsCallable('generateShareLink')
          .call<Map<String, dynamic>>({'letterId': letterId});
      return result.data['url'] as String?;
    } catch (e) {
      debugPrint('[ShareLinkService] generateShareLink error: $e');
      return null;
    }
  }

  /// Claims a letter using a share token.
  /// Called when the recipient opens a shared link and is signed in.
  /// Returns the letterId on success, or null on failure.
  static Future<String?> claimShareLink(String shareToken) async {
    try {
      final result = await _functions
          .httpsCallable('claimShareLink')
          .call<Map<String, dynamic>>({'shareToken': shareToken});
      return result.data['letterId'] as String?;
    } catch (e) {
      debugPrint('[ShareLinkService] claimShareLink error: $e');
      return null;
    }
  }

  /// Revokes a share link for a letter.
  /// If [regenerate] is true, a new token is generated and returned.
  static Future<String?> revokeShareLink(
    String letterId, {
    bool regenerate = false,
  }) async {
    try {
      final result = await _functions
          .httpsCallable('revokeShareLink')
          .call<Map<String, dynamic>>({
        'letterId': letterId,
        'regenerate': regenerate,
      });
      return result.data['newUrl'] as String?;
    } catch (e) {
      debugPrint('[ShareLinkService] revokeShareLink error: $e');
      return null;
    }
  }
}
