/// Phases for [LetterSendService] and granular errors when sending a letter.
enum LetterSendStep {
  moderation,
  voiceUpload,
  loadSenderProfile,
  checkFriendship,
  commitFirestore,
}
