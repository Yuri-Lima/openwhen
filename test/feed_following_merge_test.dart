import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openwhen/features/feed/domain/feed_following_merge.dart';

void main() {
  group('chunkIds', () {
    test('empty', () {
      expect(chunkIds([]), isEmpty);
    });

    test('splits at chunkSize', () {
      expect(
        chunkIds(['a', 'b', 'c', 'd'], chunkSize: 2),
        [
          ['a', 'b'],
          ['c', 'd'],
        ],
      );
    });

    test('last chunk smaller', () {
      expect(
        chunkIds(['0', '1', '2', '3', '4'], chunkSize: 2),
        [
          ['0', '1'],
          ['2', '3'],
          ['4'],
        ],
      );
    });
  });

  group('mergeFollowChunkSnapshots', () {
    late FakeFirebaseFirestore fs;
    late Timestamp min;

    setUp(() {
      fs = FakeFirebaseFirestore();
      min = Timestamp.fromDate(DateTime(2020, 1, 1));
    });

    test('drops docs before openedAtMin', () async {
      await fs.collection('letters').doc('old').set({
        'openedAt': Timestamp.fromDate(DateTime(2019, 6, 1)),
        'senderUid': 'u1',
      });
      final snap = await fs.collection('letters').get();
      final out = mergeFollowChunkSnapshots(
        allDocs: snap.docs,
        openedAtMin: min,
        blockedSenderUids: {},
      );
      expect(out, isEmpty);
    });

    test('dedupes by id and sorts by openedAt desc', () async {
      final t1 = Timestamp.fromDate(DateTime(2021, 1, 1));
      final t2 = Timestamp.fromDate(DateTime(2022, 1, 1));
      await fs.collection('letters').doc('a').set({
        'openedAt': t1,
        'senderUid': 'u1',
      });
      await fs.collection('letters').doc('b').set({
        'openedAt': t2,
        'senderUid': 'u2',
      });
      final snap = await fs.collection('letters').get();
      final out = mergeFollowChunkSnapshots(
        allDocs: snap.docs,
        openedAtMin: min,
        blockedSenderUids: {},
      );
      expect(out.map((d) => d.id).toList(), ['b', 'a']);
    });

    test('hides blocked senders', () async {
      await fs.collection('letters').doc('x').set({
        'openedAt': Timestamp.fromDate(DateTime(2021, 1, 1)),
        'senderUid': 'bad',
      });
      final snap = await fs.collection('letters').get();
      final out = mergeFollowChunkSnapshots(
        allDocs: snap.docs,
        openedAtMin: min,
        blockedSenderUids: {'bad'},
      );
      expect(out, isEmpty);
    });
  });

  group('sortByLikeCountThenOpenedAt', () {
    test('caps maxItems', () async {
      final fs = FakeFirebaseFirestore();
      for (var i = 0; i < 5; i++) {
        await fs.collection('letters').doc('$i').set({
          'likeCount': i,
          'openedAt': Timestamp.fromMillisecondsSinceEpoch(1000 * i),
        });
      }
      final snap = await fs.collection('letters').get();
      final out = sortByLikeCountThenOpenedAt(snap.docs, maxItems: 2);
      expect(out.length, 2);
      expect(out.first.data()['likeCount'], 4);
    });
  });
}
