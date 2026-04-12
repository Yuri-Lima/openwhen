import '../services/safe_callable.dart';
import 'admin_moderation_info.dart';

/// Callable wrappers for admin moderation and ops ([functions/src/admin.ts](functions/src/admin.ts)).
class AdminFunctionsService {
  Future<List<Map<String, dynamic>>> listPendingReports({int limit = 50}) async {
    final result = await SafeCallable.call(
      'adminListPendingReports',
      data: <String, dynamic>{'limit': limit},
      label: 'adminListPendingReports',
    );
    final data = _asMap(result.data);
    final raw = data['reports'];
    if (raw is! List) return [];
    return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<List<Map<String, dynamic>>> listRecentFeedback({int limit = 50}) async {
    final result = await SafeCallable.call(
      'adminListRecentFeedback',
      data: <String, dynamic>{'limit': limit},
      label: 'adminListRecentFeedback',
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
    await SafeCallable.call(
      'adminResolveReport',
      data: <String, dynamic>{
        'reportId': reportId,
        'resolution': resolution,
      },
      label: 'adminResolveReport',
    );
  }

  Future<AdminModerationInfo> getModerationInfo() async {
    final result = await SafeCallable.call(
      'adminGetModerationInfo',
      label: 'adminGetModerationInfo',
    );
    final data = _asMap(result.data);
    return AdminModerationInfo(
      providerId: data['providerId'] as String? ?? 'unknown',
      credentialsConfigured: data['credentialsConfigured'] == true,
    );
  }

  Future<List<Map<String, dynamic>>> listModerationIncidents({int limit = 50}) async {
    final result = await SafeCallable.call(
      'adminListModerationIncidents',
      data: <String, dynamic>{'limit': limit},
      label: 'adminListModerationIncidents',
    );
    final data = _asMap(result.data);
    final raw = data['items'];
    if (raw is! List) return [];
    return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  /// Human moderation queue (`adminListPendingModerationReviews`).
  Future<(List<Map<String, dynamic>>, String?)> listPendingModerationReviews({
    int limit = 50,
    String? cursorId,
  }) async {
    final result = await SafeCallable.call(
      'adminListPendingModerationReviews',
      data: <String, dynamic>{
        'limit': limit,
        if (cursorId != null) 'cursorId': cursorId,
      },
      label: 'adminListPendingModerationReviews',
    );
    final data = _asMap(result.data);
    final raw = data['items'];
    final items = raw is List
        ? raw.map((e) => Map<String, dynamic>.from(e as Map)).toList()
        : <Map<String, dynamic>>[];
    final next = data['nextCursor'] as String?;
    return (items, next);
  }

  Future<Map<String, dynamic>> resolveModerationReview({
    required String reviewId,
    required String decision,
    String? userFeedback,
  }) async {
    final result = await SafeCallable.call(
      'adminResolveModerationReview',
      data: <String, dynamic>{
        'reviewId': reviewId,
        'decision': decision,
        if (userFeedback != null) 'userFeedback': userFeedback,
      },
      label: 'adminResolveModerationReview',
    );
    return _asMap(result.data);
  }

  /// One-shot: recalculates `followersCount` / `followingCount` for every user
  /// based on the actual `follows` collection. Returns stats about the run.
  Future<Map<String, dynamic>> backfillFollowCounters() async {
    final result = await SafeCallable.call(
      'backfillFollowCounters',
      label: 'backfillFollowCounters',
    );
    return _asMap(result.data);
  }

  Map<String, dynamic> _asMap(Object? data) {
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
}
