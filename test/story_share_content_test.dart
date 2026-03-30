import 'package:flutter_test/flutter_test.dart';
import 'package:openwhen/shared/social/story_share_content.dart';

void main() {
  test('StoryShareContent.letter truncates long titles', () {
    final long = '${'a' * 60}';
    final c = StoryShareContent.letter(docId: 'x', title: long, dateSubtitle: 'Opens on 1 Jan');
    expect(c.truncatedTitle.length, lessThanOrEqualTo(StoryShareContent.maxTitleLength));
    expect(c.truncatedTitle.endsWith('…'), isTrue);
    expect(c.deepLink, 'https://openwhen.app/letter/x');
  });

  test('StoryShareContent.capsule combines title and theme', () {
    final c = StoryShareContent.capsule(
      docId: 'c1',
      title: 'Hello',
      themeLabel: 'Goals',
      dateSubtitle: 'Opened',
    );
    expect(c.truncatedTitle.length, lessThanOrEqualTo(StoryShareContent.maxTitleLength));
    expect(c.deepLink, 'https://openwhen.app/capsule/c1');
  });
}
