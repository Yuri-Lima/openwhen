/// Allowlisted fields for social story images — never pass raw Firestore maps to painters.
class StoryShareContent {
  const StoryShareContent({
    required this.kind,
    required this.truncatedTitle,
    required this.deepLink,
    required this.dateSubtitle,
    required this.brandLine,
  });

  final StoryShareKind kind;
  final String truncatedTitle;
  final String deepLink;
  final String dateSubtitle;
  final String brandLine;

  static const int maxTitleLength = 48;

  static String _truncate(String s) {
    final t = s.trim();
    if (t.length <= maxTitleLength) return t;
    return '${t.substring(0, maxTitleLength - 1)}…';
  }

  /// Letter: no message body — title + date line from caller (localized).
  factory StoryShareContent.letter({
    required String docId,
    required String title,
    required String dateSubtitle,
  }) {
    return StoryShareContent(
      kind: StoryShareKind.letter,
      truncatedTitle: _truncate(title),
      deepLink: 'https://openwhen.app/letter/$docId',
      dateSubtitle: dateSubtitle,
      brandLine: 'openwhen.app',
    );
  }

  /// Capsule: theme/title only — no Q&A.
  factory StoryShareContent.capsule({
    required String docId,
    required String title,
    required String themeLabel,
    required String dateSubtitle,
  }) {
    final combined = title.trim().isEmpty ? themeLabel : '${_truncate(title)} · $themeLabel';
    return StoryShareContent(
      kind: StoryShareKind.capsule,
      truncatedTitle: _truncate(combined),
      deepLink: 'https://openwhen.app/capsule/$docId',
      dateSubtitle: dateSubtitle,
      brandLine: 'openwhen.app',
    );
  }
}

enum StoryShareKind { letter, capsule }
