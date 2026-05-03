import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

import 'safe_callable.dart';

/// Best-effort access logging for Marco Civil da Internet Art. 15.
///
/// Calls the `logAccess` Cloud Function after each successful
/// authentication. The Cloud Function captures the client IP
/// (server-side) and writes to the `accessLogs` collection.
///
/// Fire-and-forget: failures are silently logged to debugPrint
/// and never block the auth flow.
class AccessLogService {
  AccessLogService._();

  static Future<void> logLogin({required String authMethod}) async {
    try {
      final platform = kIsWeb
          ? 'web'
          : Platform.isIOS
              ? 'ios'
              : Platform.isAndroid
                  ? 'android'
                  : 'other';

      // Fire-and-forget — don't await in the caller's auth flow.
      await SafeCallable.call(
        'logAccess',
        data: {
          'platform': platform,
          'authMethod': authMethod,
        },
        label: 'logAccess',
      );
    } catch (e) {
      debugPrint('AccessLogService.logLogin failed (best-effort): $e');
    }
  }
}
