import 'package:flutter_test/flutter_test.dart';
import 'package:openwhen/features/feed/presentation/providers/feed_pinned_filters_provider.dart';

void main() {
  group('parsePinnedFilters', () {
    test('parses ordered ids', () {
      expect(
        FeedPinnedFiltersNotifier.parsePinnedFilters('2,0,1'),
        [2, 0, 1],
      );
    });

    test('dedupes preserving first occurrence', () {
      expect(
        FeedPinnedFiltersNotifier.parsePinnedFilters('1,1,2'),
        [1, 2],
      );
    });

    test('stops at 3', () {
      expect(
        FeedPinnedFiltersNotifier.parsePinnedFilters('0,1,2,3'),
        [0, 1, 2],
      );
    });

    test('rejects invalid and empty', () {
      expect(FeedPinnedFiltersNotifier.parsePinnedFilters(''), null);
      expect(FeedPinnedFiltersNotifier.parsePinnedFilters('x,y'), null);
    });
  });
}
