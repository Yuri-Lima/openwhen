import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;

/// Global serial queue for Firebase HTTPS callable invocations.
///
/// On iOS 26.x the native Firebase/gRPC Swift runtime can SIGABRT when
/// multiple `HTTPSCallable.call()` requests overlap — even from different
/// screens. Root cause: Swift 6.3 `async let` teardown bug in
/// `FunctionsContextProvider.context()` (firebase-ios-sdk#15974).
///
/// This queue guarantees at most **one** callable in flight at a time,
/// with a configurable cooldown between consecutive calls so the native async
/// task deallocation can finish cleanly.
///
/// Usage:
/// ```dart
/// final result = await CallableQueue.enqueue(
///   () => functions.httpsCallable('myFunc').call(payload),
///   label: 'myFunc', // optional, for debug logging + Crashlytics keys
/// );
/// ```
class CallableQueue {
  CallableQueue._();

  static final _lock = _SerialLock();

  /// Cooldown inserted after each callable completes, before the next one
  /// is allowed to start. Baseline: 400ms → bumped to 600ms (2026-04-11)
  /// after SIGABRT on iOS 26.5. See TROUBLESHOOTING.md §5.
  static const _cooldown = Duration(milliseconds: 600);

  /// Enqueues [fn] so it executes only when no other callable is in flight.
  /// Returns the result of [fn]. Exceptions propagate normally.
  static Future<T> enqueue<T>(
    Future<T> Function() fn, {
    String? label,
  }) {
    return _lock.run(() async {
      if (label != null) {
        FirebaseCrashlytics.instance.setCustomKey('last_callable', label);
        FirebaseCrashlytics.instance.setCustomKey(
          'callable_start_ms',
          DateTime.now().millisecondsSinceEpoch.toString(),
        );
      }
      if (kDebugMode && label != null) {
        debugPrint('[CallableQueue] start: $label');
      }
      try {
        return await fn();
      } finally {
        await Future<void>.delayed(_cooldown);
        if (kDebugMode && label != null) {
          debugPrint('[CallableQueue] done:  $label');
        }
      }
    });
  }
}

/// Simple FIFO mutex: each [run] call waits for the previous one to finish.
class _SerialLock {
  Future<void> _last = Future.value();

  Future<T> run<T>(Future<T> Function() fn) {
    final completer = Completer<T>();
    final prev = _last;
    _last = completer.future.then((_) {}, onError: (_) {});
    prev.then((_) async {
      try {
        completer.complete(await fn());
      } catch (e, st) {
        completer.completeError(e, st);
      }
    });
    return completer.future;
  }
}
