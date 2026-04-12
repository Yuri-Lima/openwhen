import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/system_config_provider.dart';
import 'moderation_functions_service.dart';

/// Outcome of pre-send AI moderation for letters and capsules.
enum ModerationDecision {
  /// Score below warning threshold — send normally.
  allowed,

  /// Score between warning and block thresholds — user decides.
  warning,

  /// Score above block threshold or provider flagged — do not send.
  blocked,

  /// AI unavailable and fail-closed policy — do not send.
  unavailable,

  /// AI moderation disabled or SKIP_AI_MODERATION — send normally.
  skipped,
}

class SendModerationResult {
  const SendModerationResult({
    required this.decision,
    this.reason,
    this.maxScore,
  });

  final ModerationDecision decision;
  final String? reason;

  /// Highest category score returned by the provider (0.0–1.0).
  final double? maxScore;
}

/// Centralised AI moderation gate for letters and capsules.
///
/// Thresholds are compile-time constants from `dart_defines.json`
/// (resolved via `--dart-define-from-file`).  Zero runtime cost.
class SendModerationHelper {
  SendModerationHelper._();

  // ── compile-time thresholds ──────────────────────────────────────────
  static const bool _kSkipAiModeration =
      bool.fromEnvironment('SKIP_AI_MODERATION');

  /// Scores at or above this trigger a *warning* dialog (user may override).
  static const double warningThreshold = double.fromEnvironment(
    'MODERATION_WARNING_THRESHOLD',
    defaultValue: 0.40,
  );

  /// Scores at or above this (or provider `flagged`) *block* the send.
  static const double blockThreshold = double.fromEnvironment(
    'MODERATION_BLOCK_THRESHOLD',
    defaultValue: 0.70,
  );

  // ── public API ───────────────────────────────────────────────────────

  /// Run AI moderation on [text] before saving a letter or capsule.
  ///
  /// [contentType] should be `'letter'` or `'capsule'`.
  static Future<SendModerationResult> moderate({
    required WidgetRef ref,
    required String text,
    required String contentType,
    required String langCode,
    String? letterId,
  }) async {
    // ─ check config flags ─────────────────────────────────────────────
    final cfg = ref.read(systemConfigProvider).value;
    final aiOn =
        !_kSkipAiModeration && cfg?.aiModerationEnabled == true;
    final failClosed = cfg?.aiModerationFailClosed != false;

    if (!aiOn) {
      return const SendModerationResult(decision: ModerationDecision.skipped);
    }

    // ─ call Cloud Function ────────────────────────────────────────────
    try {
      final svc = ModerationFunctionsService();
      final r = await svc.moderateText(
        text: text,
        contentType: contentType,
        locale: langCode,
        letterId: letterId,
      );

      // Server explicitly blocked (e.g. human queue, hard flag).
      if (!r.allowed) {
        return SendModerationResult(
          decision: ModerationDecision.blocked,
          reason: r.reason ?? 'ai_blocked',
          maxScore: r.maxScore,
        );
      }

      // Classify using compile-time thresholds + provider maxScore.
      final score = r.maxScore ?? 0.0;

      if (r.flagged == true || score >= blockThreshold) {
        return SendModerationResult(
          decision: ModerationDecision.blocked,
          reason: 'ai_blocked',
          maxScore: r.maxScore,
        );
      }

      if (score >= warningThreshold) {
        return SendModerationResult(
          decision: ModerationDecision.warning,
          reason: 'ai_warning',
          maxScore: r.maxScore,
        );
      }

      return SendModerationResult(
        decision: ModerationDecision.allowed,
        maxScore: r.maxScore,
      );
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('[SendModerationHelper] error: $e');
      }
      if (failClosed) {
        return const SendModerationResult(
          decision: ModerationDecision.unavailable,
          reason: 'moderation_unavailable',
        );
      }
      // Fail-open: allow send.
      return const SendModerationResult(decision: ModerationDecision.allowed);
    }
  }
}
