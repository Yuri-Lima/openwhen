import 'package:cloud_functions/cloud_functions.dart';

import '../billing/firebase_functions_region.dart';
import '../services/callable_queue.dart';

/// Result of callable `moderateContent` (aligned with Cloud Functions JSON).
class ModerationCallResult {
  const ModerationCallResult({
    required this.allowed,
    required this.source,
    this.reason,
    this.flagged,
    this.reviewId,
    this.maxScore,
  });

  final bool allowed;
  /// `provider` | `fallback` | `skipped`
  final String source;
  final String? reason;
  final bool? flagged;
  final String? reviewId;

  /// Highest category_score returned by the provider (0.0–1.0).
  /// Used by the client to classify severity against compile-time thresholds.
  final double? maxScore;
}

class ModerationFunctionsService {
  ModerationFunctionsService({FirebaseFunctions? functions})
      : _functions =
            functions ?? FirebaseFunctions.instanceFor(region: kFirebaseFunctionsRegion);

  final FirebaseFunctions _functions;

  Future<ModerationCallResult> moderateText({
    required String text,
    String? contentType,
    String? locale,
    String? letterId,
  }) async {
    final payload = <String, dynamic>{'text': text};
    if (contentType != null) payload['contentType'] = contentType;
    if (locale != null) payload['locale'] = locale;
    if (letterId != null) payload['letterId'] = letterId;
    final result = await CallableQueue.enqueue(
      () => _functions.httpsCallable('moderateContent').call(payload),
      label: 'moderateContent',
    );
    final data = _asMap(result.data);
    return ModerationCallResult(
      allowed: data['allowed'] == true,
      source: data['source'] as String? ?? 'provider',
      reason: data['reason'] as String?,
      flagged: data['flagged'] as bool?,
      reviewId: data['reviewId'] as String?,
      maxScore: (data['maxScore'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> _asMap(Object? data) {
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
}
