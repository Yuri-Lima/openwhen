/// Product field `contentMode` on `capsules` documents.
abstract final class CapsuleContentMode {
  static const String singleAuthor = 'singleAuthor';
  static const String multiContributor = 'multiContributor';
}

/// Defaults to [CapsuleContentMode.singleAuthor] when missing (legacy docs).
String capsuleContentModeFromData(Map<String, dynamic>? data) {
  final m = data?['contentMode'];
  if (m == CapsuleContentMode.multiContributor) {
    return CapsuleContentMode.multiContributor;
  }
  return CapsuleContentMode.singleAuthor;
}

/// Max participants (including creator) for collective capsules — aligned with Firestore rules.
const int kCapsuleMaxParticipants = 20;

/// Whether [uid] may access the capsule (legacy: sender/receiver only).
bool capsuleIsParticipant(Map<String, dynamic> data, String uid) {
  final puids = data['participantUids'];
  if (puids is List) {
    for (final e in puids) {
      if (e == uid) return true;
    }
  }
  return data['senderUid'] == uid || data['receiverUid'] == uid;
}
