import 'package:flutter_test/flutter_test.dart';
import 'package:openwhen/shared/utils/music_url.dart';

void main() {
  group('isValidHttpsMusicUrl', () {
    test('accepts allowlisted hosts', () {
      expect(
        isValidHttpsMusicUrl('https://open.spotify.com/track/abc'),
        isTrue,
      );
      expect(
        isValidHttpsMusicUrl('https://music.youtube.com/watch?v=x'),
        isTrue,
      );
      expect(
        isValidHttpsMusicUrl('https://youtu.be/abc123'),
        isTrue,
      );
    });

    test('rejects non-https', () {
      expect(isValidHttpsMusicUrl('http://open.spotify.com/x'), isFalse);
    });

    test('rejects arbitrary https hosts', () {
      expect(isValidHttpsMusicUrl('https://evil.example/phishing'), isFalse);
    });

    test('rejects null or empty', () {
      expect(isValidHttpsMusicUrl(null), isFalse);
      expect(isValidHttpsMusicUrl(''), isFalse);
      expect(isValidHttpsMusicUrl('   '), isFalse);
    });
  });
}
