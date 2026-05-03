/// Parsed `https://whenote.app/letter/...` / `.../capsule/...` / `.../open/...` before navigation.
class PendingDeepLink {
  PendingDeepLink._();

  static String? pendingLetterId;
  static String? pendingCapsuleId;
  /// Share token from a /open/{token} deep link.
  static String? pendingShareToken;

  /// Stores letter, capsule, or share-link token from a universal link / app link.
  static void storeFromUri(Uri uri) {
    final host = uri.host.toLowerCase();
    if (host != 'whenote.app' && host != 'www.whenote.app') return;
    final segs = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segs.length >= 2 && segs[0] == 'letter') {
      pendingLetterId = segs[1];
      pendingCapsuleId = null;
      pendingShareToken = null;
      return;
    }
    if (segs.length >= 2 && segs[0] == 'capsule') {
      pendingCapsuleId = segs[1];
      pendingLetterId = null;
      pendingShareToken = null;
      return;
    }
    if (segs.length >= 2 && segs[0] == 'open') {
      pendingShareToken = segs[1];
      pendingLetterId = null;
      pendingCapsuleId = null;
      return;
    }
  }

  static void clear() {
    pendingLetterId = null;
    pendingCapsuleId = null;
    pendingShareToken = null;
  }
}
