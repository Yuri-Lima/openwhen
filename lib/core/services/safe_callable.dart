import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode, kIsWeb;
import 'package:http/http.dart' as http;

import '../billing/firebase_functions_region.dart';
import 'callable_queue.dart';

/// Thin wrapper around the result of a callable invocation.
///
/// Mirrors [HttpsCallableResult.data] so callers can use `.data` uniformly.
class CallableResult<T> {
  const CallableResult(this.data);
  final T data;
}

/// Safely invokes Firebase HTTPS callable functions across all platforms.
///
/// On **iOS** the native `HTTPSCallable.call()` crashes on iOS 26.x due to a
/// Swift 6.3 `async let` teardown regression in Firebase iOS SDK 12.9.0
/// (firebase-ios-sdk#15974, fixed in 12.12.0 which FlutterFire doesn't ship
/// yet). This class detects iOS and calls the Cloud Function via plain HTTP
/// (`package:http`), completely bypassing the native Swift code.
///
/// On other platforms the native SDK is used normally.
///
/// All invocations are serialised through [CallableQueue] to prevent overlap.
class SafeCallable {
  SafeCallable._();

  // TODO(remove-http-fallback): When FlutterFire ships BoM >= 4.12.0 with
  //  Firebase iOS SDK 12.12.0+, set this to `false` (or delete SafeCallable
  //  entirely and revert callers to the native SDK).
  //  Track: https://github.com/firebase/flutterfire/issues/18153
  static bool get _useHttpFallback => !kIsWeb && Platform.isIOS;

  // ── public API ──────────────────────────────────────────────────────────

  /// Call [functionName] with optional [data], serialised via [CallableQueue].
  ///
  /// Returns a [CallableResult] whose `.data` mirrors the callable response.
  static Future<CallableResult> call(
    String functionName, {
    Object? data,
    String? label,
  }) {
    return CallableQueue.enqueue(
      () => _invoke(functionName, data: data),
      label: label ?? functionName,
    );
  }

  // ── internals ───────────────────────────────────────────────────────────

  static Future<CallableResult> _invoke(
    String functionName, {
    Object? data,
  }) async {
    if (_useHttpFallback) {
      return _callViaHttp(functionName, data);
    }
    final fns =
        FirebaseFunctions.instanceFor(region: kFirebaseFunctionsRegion);
    final result = await fns.httpsCallable(functionName).call(data);
    return CallableResult(result.data);
  }

  /// Direct HTTPS POST using the Firebase callable wire protocol (v2).
  ///
  /// Wire format:
  /// - URL:  `https://<region>-<projectId>.cloudfunctions.net/<name>`
  /// - Body: `{"data": <payload>}`
  /// - Auth: `Authorization: Bearer <idToken>`
  /// - Response success: `{"result": <payload>}`
  /// - Response error:   `{"error": {"status": "...", "message": "..."}}`
  static Future<CallableResult> _callViaHttp(
    String functionName,
    Object? data,
  ) async {
    final region = kFirebaseFunctionsRegion;
    final projectId = Firebase.app().options.projectId;
    final url = Uri.parse(
      'https://$region-$projectId.cloudfunctions.net/$functionName',
    );

    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();

    // App Check token — required by enforceAppCheck on Cloud Functions.
    // getToken() contacts DeviceCheck/AppAttest — timeout guards against
    // potential iOS SDK deadlock (firebase-ios-sdk#15974).
    String? appCheckToken;
    try {
      appCheckToken = await FirebaseAppCheck.instance
          .getToken()
          .timeout(const Duration(seconds: 8));
    } catch (e) {
      // Log in ALL modes — App Check failures cause silent 401s that are
      // extremely hard to diagnose in production.
      debugPrint('[SafeCallable] App Check token fetch failed for '
          '$functionName: $e');
    }

    if (appCheckToken == null || appCheckToken.isEmpty) {
      debugPrint('[SafeCallable] WARNING: No App Check token for '
          '$functionName — server may reject with 401 if enforceAppCheck '
          'is enabled.');
    }

    if (kDebugMode) {
      debugPrint('[SafeCallable] HTTP POST $functionName (iOS fallback)');
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        if (appCheckToken != null) 'X-Firebase-AppCheck': appCheckToken,
      },
      body: jsonEncode({'data': data}),
    );

    if (response.statusCode != 200) {
      final body = _tryDecodeJson(response.body);
      final error = body?['error'];
      final code = _mapHttpStatusToCode(response.statusCode, error);
      final message = error is Map
          ? (error['message'] as String? ?? 'Callable $functionName failed')
          : 'HTTP ${response.statusCode}';
      throw FirebaseFunctionsException(code: code, message: message);
    }

    final body = jsonDecode(response.body);
    return CallableResult(body['result']);
  }

  static Map<String, dynamic>? _tryDecodeJson(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return null;
  }

  /// Maps an HTTP status to a Firebase Functions error code string.
  static String _mapHttpStatusToCode(int status, Object? error) {
    if (error is Map) {
      final s = error['status'];
      if (s is String && s.isNotEmpty) return s;
    }
    return switch (status) {
      400 => 'invalid-argument',
      401 => 'unauthenticated',
      403 => 'permission-denied',
      404 => 'not-found',
      409 => 'already-exists',
      429 => 'resource-exhausted',
      499 => 'cancelled',
      500 => 'internal',
      501 => 'unimplemented',
      503 => 'unavailable',
      504 => 'deadline-exceeded',
      _ => 'unknown',
    };
  }
}
