/// Stable ids for [users/{uid}/badgeUnlocks/{badgeId}] — do not rename once shipped.
abstract final class BadgeId {
  static const firstLetterSent = 'first_letter_sent';
  static const firstLetterOpened = 'first_letter_opened';
  static const firstPublic = 'first_public';
  static const lettersSentFive = 'letters_sent_five';
  static const lettersSentTen = 'letters_sent_ten';
  static const voiceLetter = 'voice_letter';

  static const List<String> all = [
    firstLetterSent,
    firstLetterOpened,
    firstPublic,
    lettersSentFive,
    lettersSentTen,
    voiceLetter,
  ];
}
