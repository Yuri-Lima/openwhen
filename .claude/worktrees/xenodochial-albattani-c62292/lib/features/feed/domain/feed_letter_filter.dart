/// Pure helpers for which public letters the current viewer should see.

/// Returns `false` when [senderUid] is in [blockedSenderUids] (viewer blocked sender).
bool isFeedLetterVisibleForViewer({
  required Map<String, dynamic> letterData,
  required Set<String> blockedSenderUids,
}) {
  final sender = letterData['senderUid'] as String? ?? '';
  if (sender.isEmpty) return true;
  return !blockedSenderUids.contains(sender);
}
