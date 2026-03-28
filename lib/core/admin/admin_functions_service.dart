import 'package:cloud_functions/cloud_functions.dart';

import '../billing/firebase_functions_region.dart';

/// Callable wrappers for moderation ([functions/src/admin.ts](functions/src/admin.ts)).
class AdminFunctionsService {
  AdminFunctionsService({FirebaseFunctions? functions})
      : _functions =
            functions ?? FirebaseFunctions.instanceFor(region: kFirebaseFunctionsRegion);

  final FirebaseFunctions _functions;

  Future<List<Map<String, dynamic>>> listPendingReports({int limit = 50}) async {
    final result = await _functions.httpsCallable('adminListPendingReports').call(
      <String, dynamic>{'limit': limit},
    );
    final data = _asMap(result.data);
    final raw = data['reports'];
    if (raw is! List) return [];
    return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<List<Map<String, dynamic>>> listRecentFeedback({int limit = 50}) async {
    final result = await _functions.httpsCallable('adminListRecentFeedback').call(
      <String, dynamic>{'limit': limit},
    );
    final data = _asMap(result.data);
    final raw = data['items'];
    if (raw is! List) return [];
    return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> resolveReport({
    required String reportId,
    required String resolution,
  }) async {
    await _functions.httpsCallable('adminResolveReport').call(<String, dynamic>{
      'reportId': reportId,
      'resolution': resolution,
    });
  }

  Map<String, dynamic> _asMap(Object? data) {
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
}
