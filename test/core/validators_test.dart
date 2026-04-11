import 'package:flutter_test/flutter_test.dart';
import 'package:openwhen/core/utils/validators.dart';

void main() {
  group('Validators.isValidEmail', () {
    test('accepts valid emails', () {
      expect(Validators.isValidEmail('user@domain.com'), isTrue);
      expect(Validators.isValidEmail('user+tag@domain.co.uk'), isTrue);
      expect(Validators.isValidEmail('first.last@company.org'), isTrue);
      expect(Validators.isValidEmail('  user@domain.com  '), isTrue);
    });

    test('rejects emails without TLD', () {
      expect(Validators.isValidEmail('user@domain'), isFalse);
    });

    test('rejects emails with missing local part', () {
      expect(Validators.isValidEmail('@domain.com'), isFalse);
    });

    test('rejects emails with missing domain', () {
      expect(Validators.isValidEmail('user@'), isFalse);
    });

    test('rejects emails with spaces', () {
      expect(Validators.isValidEmail('user @domain.com'), isFalse);
      expect(Validators.isValidEmail('user@dom ain.com'), isFalse);
      expect(Validators.isValidEmail('us er@domain.com'), isFalse);
    });

    test('rejects empty string', () {
      expect(Validators.isValidEmail(''), isFalse);
    });

    test('rejects bare text', () {
      expect(Validators.isValidEmail('notanemail'), isFalse);
    });
  });
}
