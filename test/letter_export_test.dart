import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:openwhen/features/letters/export/letter_export_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  group('buildLettersPdf', () {
    test('throws on empty docs', () async {
      await expectLater(
        buildLettersPdf(docs: [], localeName: 'en'),
        throwsArgumentError,
      );
    });

    test('produces non-empty PDF bytes', () async {
      final fs = FakeFirebaseFirestore();
      await fs.collection('letters').doc('l1').set({
        'title': 'Hello',
        'message': 'Body',
        'senderName': 'A',
        'receiverName': 'B',
        'openedAt': Timestamp.now(),
      });
      final snap = await fs.collection('letters').get();
      final bytes = await buildLettersPdf(docs: snap.docs, localeName: 'en');
      expect(bytes.isNotEmpty, isTrue);
      expect(bytes.length, greaterThan(100));
    });

    test('rejects invalid musicUrl', () async {
      final fs = FakeFirebaseFirestore();
      await fs.collection('letters').doc('l1').set({
        'title': 'T',
        'message': 'M',
        'senderName': 'A',
        'receiverName': 'B',
        'openedAt': Timestamp.now(),
        'musicUrl': 'http://insecure.example.com/track',
      });
      final snap = await fs.collection('letters').get();
      await expectLater(
        buildLettersPdf(docs: snap.docs, localeName: 'en'),
        throwsStateError,
      );
    });
  });
}
