/// Public user row returned by [UserSearchService] — no email.
class UserSearchResult {
  const UserSearchResult({
    required this.uid,
    required this.username,
    required this.publicName,
    this.photoUrl,
  });

  final String uid;
  final String username;

  /// Display name shown in UI (`displayName` ?? `name`).
  final String publicName;
  final String? photoUrl;

  /// Map for screens that still expect `Map<String, dynamic>` (legacy chips).
  Map<String, dynamic> toLegacyMap() => {
    'uid': uid,
    'username': username,
    'displayName': publicName,
    'name': publicName,
    'photoUrl': photoUrl,
  };
}
