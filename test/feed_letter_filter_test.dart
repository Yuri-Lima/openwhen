import 'package:flutter_test/flutter_test.dart';
import 'package:openwhen/features/feed/domain/feed_letter_filter.dart';

void main() {
  group('isFeedLetterVisibleForViewer', () {
    test('shows letter when sender not blocked', () {
      expect(
        isFeedLetterVisibleForViewer(
          letterData: {'senderUid': 'a'},
          blockedSenderUids: {'b'},
        ),
        isTrue,
      );
    });

    test('hides letter when sender is blocked', () {
      expect(
        isFeedLetterVisibleForViewer(
          letterData: {'senderUid': 'a'},
          blockedSenderUids: {'a'},
        ),
        isFalse,
      );
    });

    test('empty sender uid stays visible', () {
      expect(
        isFeedLetterVisibleForViewer(
          letterData: <String, dynamic>{},
          blockedSenderUids: {'x'},
        ),
        isTrue,
      );
    });
  });
}
