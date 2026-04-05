import 'package:flutter_test/flutter_test.dart';
import 'package:openwhen/core/utils/email_normalization.dart';

void main() {
  group('normalizeReceiverEmailForMatching', () {
    test('trims and lowercases', () {
      expect(
        normalizeReceiverEmailForMatching('  User@Example.COM  '),
        'user@example.com',
      );
    });
  });
}
