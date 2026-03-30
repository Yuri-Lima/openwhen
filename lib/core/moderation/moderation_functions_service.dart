import 'package:cloud_functions/cloud_functions.dart';

import '../billing/firebase_functions_region.dart';

/// Result of callable `moderateContent` (aligned with Cloud Functions JSON).
class ModerationCallResult {
  const ModerationCallResult({
    required this.allowed,
    required this.source,
    this.reason,
    this.flagged,
  });

  final bool allowed;
  /// `provider` | `fallback` | `skipped`
  final String source;
  final String? reason;
  final bool? flagged;
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
  }) async {
    final payload = <String, dynamic>{'text': text};
    if (contentType != null) payload['contentType'] = contentType;
    if (locale != null) payload['locale'] = locale;
    final result = await _functions.httpsCallable('moderateContent').call(payload);
    final data = _asMap(result.data);
    return ModerationCallResult(
      allowed: data['allowed'] == true,
      source: data['source'] as String? ?? 'provider',
      reason: data['reason'] as String?,
      flagged: data['flagged'] as bool?,
    );
  }

  Map<String, dynamic> _asMap(Object? data) {
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
}
