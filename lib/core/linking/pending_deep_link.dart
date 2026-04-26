/// Parsed `https://whenote.app/letter/...` / `.../capsule/...` before navigation.
class PendingDeepLink {
  PendingDeepLink._();

  static String? pendingLetterId;
  static String? pendingCapsuleId;

  /// Stores letter or capsule id from a universal link / app link.
  static void storeFromUri(Uri uri) {
    final host = uri.host.toLowerCase();
    if (host != 'whenote.app' && host != 'www.whenote.app') return;
    final segs = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segs.length >= 2 && segs[0] == 'letter') {
      pendingLetterId = segs[1];
      pendingCapsuleId = null;
      return;
    }
    if (segs.length >= 2 && segs[0] == 'capsule') {
      pendingCapsuleId = segs[1];
      pendingLetterId = null;
    }
  }

  static void clear() {
    pendingLetterId = null;
    pendingCapsuleId = null;
  }
}
