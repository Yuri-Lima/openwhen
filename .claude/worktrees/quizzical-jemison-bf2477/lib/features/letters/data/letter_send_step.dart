/// Phases for [LetterSendService] and granular errors when sending a letter.
enum LetterSendStep {
  emailLookup,
  moderation,
  voiceUpload,
  loadSenderProfile,
  checkFriendship,
  commitFirestore,
}
