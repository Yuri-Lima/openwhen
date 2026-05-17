import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kPinnedKey = 'feed_pinned_filter_ids_v1';

/// Default quick filters: For everyone, Love, Friendship.
const List<int> kFeedPinnedFiltersDefault = [0, 1, 2];

/// Semantic filter ids: 0 = all, 1 = love, 2 = friendship bucket, 3 = family bucket.
/// User picks 1–3 unique ids to show as chips on the feed header.
final feedPinnedFiltersProvider =
    NotifierProvider<FeedPinnedFiltersNotifier, List<int>>(
  FeedPinnedFiltersNotifier.new,
);

class FeedPinnedFiltersNotifier extends Notifier<List<int>> {
  @override
  List<int> build() {
    Future.microtask(_load);
    return List<int>.from(kFeedPinnedFiltersDefault);
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kPinnedKey);
    if (raw == null || raw.isEmpty) return;
    final parsed = parsePinnedFilters(raw);
    if (parsed != null && parsed.isNotEmpty) {
      state = parsed;
    }
  }

  /// Parses comma-separated ids, preserves order, dedupes, clamps to max 3.
  static List<int>? parsePinnedFilters(String raw) {
    final parts = raw.split(',');
    final seen = <int>{};
    final out = <int>[];
    for (final p in parts) {
      final v = int.tryParse(p.trim());
      if (v == null || v < 0 || v > 3) continue;
      if (seen.contains(v)) continue;
      seen.add(v);
      out.add(v);
      if (out.length >= 3) break;
    }
    if (out.isEmpty) return null;
    return out;
  }

  Future<void> setPins(List<int> pins) async {
    final seen = <int>{};
    final next = <int>[];
    for (final p in pins) {
      if (p < 0 || p > 3) continue;
      if (seen.contains(p)) continue;
      seen.add(p);
      next.add(p);
      if (next.length >= 3) break;
    }
    if (next.isEmpty) return;
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPinnedKey, next.join(','));
  }
}
