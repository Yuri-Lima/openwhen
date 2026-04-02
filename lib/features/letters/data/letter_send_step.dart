/// Phases for [LetterSendService] and granular errors when sending a letter.
enum LetterSendStep {
  voiceUpload,
  loadSenderProfile,
  checkFriendship,
  commitFirestore,
}
