/// Allowlisted fields for social story images — never pass raw Firestore maps to painters.
class StoryShareContent {
  const StoryShareContent({
    required this.kind,
    required this.truncatedTitle,
    required this.deepLink,
    required this.dateSubtitle,
    required this.brandLine,
    this.senderName,
    this.receiverName,
    this.message,
  });

  final StoryShareKind kind;
  final String truncatedTitle;
  final String deepLink;
  final String dateSubtitle;
  final String brandLine;

  /// Only used by [StoryShareKind.paperLetter].
  final String? senderName;
  final String? receiverName;
  final String? message;

  static const int maxTitleLength = 48;
  static const int maxMessageLength = 280;

  static String _truncate(String s, [int max = maxTitleLength]) {
    final t = s.trim();
    if (t.length <= max) return t;
    return '${t.substring(0, max - 1)}…';
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
      deepLink: 'https://whenote.app/letter/$docId',
      dateSubtitle: dateSubtitle,
      brandLine: 'whenote.app',
    );
  }

  /// Paper letter: carta visual com papel, watermark e QR.
  factory StoryShareContent.paperLetter({
    required String docId,
    required String title,
    required String message,
    required String senderName,
    required String receiverName,
    required String dateSubtitle,
  }) {
    return StoryShareContent(
      kind: StoryShareKind.paperLetter,
      truncatedTitle: _truncate(title),
      deepLink: 'https://whenote.app/letter/$docId',
      dateSubtitle: dateSubtitle,
      brandLine: 'whenote.app',
      senderName: senderName,
      receiverName: receiverName,
      message: _truncate(message, maxMessageLength),
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
      deepLink: 'https://whenote.app/capsule/$docId',
      dateSubtitle: dateSubtitle,
      brandLine: 'whenote.app',
    );
  }
}

enum StoryShareKind { letter, capsule, paperLetter }
