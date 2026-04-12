import 'package:app_links/app_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import '../navigation/app_navigator_key.dart';
import 'deep_link_coordinator.dart';
import 'pending_deep_link.dart';

/// Subscribes to `https://openwhen.live/letter/...` and `/capsule/...` while the app runs.
Future<void> initDeepLinks() async {
  if (kIsWeb) {
    return;
  }
  final appLinks = AppLinks();

  try {
    final initial = await appLinks.getInitialLink();
    if (initial != null) {
      PendingDeepLink.storeFromUri(initial);
    }
  } catch (e, st) {
    debugPrint('[DeepLink] getInitialLink: $e\n$st');
  }

  appLinks.uriLinkStream.listen((Uri uri) {
    PendingDeepLink.storeFromUri(uri);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final ctx = rootNavigatorKey.currentContext;
      if (ctx == null || !ctx.mounted) return;
      if (FirebaseAuth.instance.currentUser == null) return;
      DeepLinkCoordinator.handlePendingAfterSignIn(ctx);
    });
  });
}
