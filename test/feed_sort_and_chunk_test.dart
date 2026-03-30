import 'package:flutter_test/flutter_test.dart';
import 'package:openwhen/features/feed/data/following_feed_merged_stream.dart';
import 'package:openwhen/features/letters/export/export_url_allowlist.dart';

void main() {
  test('chunkList splits at 10', () {
    final uids = List.generate(25, (i) => 'u$i');
    final chunks = chunkList(uids, 10);
    expect(chunks.length, 3);
    expect(chunks[0].length, 10);
    expect(chunks[1].length, 10);
    expect(chunks[2].length, 5);
  });

  test('sanitizeExportSegment strips unsafe chars', () {
    expect(sanitizeExportSegment('abc/../x'), 'abc____x');
    expect(sanitizeExportSegment('id-12_3'), 'id-12_3');
  });

  test('isAllowedLetterAssetDownloadUrl rejects non-storage', () {
    expect(isAllowedLetterAssetDownloadUrl('https://evil.com/voice.mp3'), false);
  });
}
