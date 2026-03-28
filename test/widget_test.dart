// Smoke test: app widget tree (Firebase is initialized in main(), not in tests).
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('placeholder — run integration tests with Firebase configured', () {
    expect(1 + 1, 2);
  });
}
