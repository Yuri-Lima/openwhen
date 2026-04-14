import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart' show Share, XFile;

import '../../core/config/facebook_app_config.dart';
import 'instagram_stories_platform.dart';
import 'story_asset_builder.dart';
import 'story_share_content.dart';

enum StoriesShareOutcome { nativeOpened, fallback }

/// Orchestrates PNG generation, native Instagram Stories, fallback [Share], and temp file cleanup.
class InstagramStoriesShareService {
  InstagramStoriesShareService._();

  static Future<StoriesShareOutcome> share({
    required BuildContext context,
    required StoryShareContent content,
    required String shareText,
    required String shareSubject,
    Rect? sharePositionOrigin,
  }) async {
    File? pngFile;
    try {
      // ---------- 1. Build story PNG ----------
      try {
        pngFile = await StoryAssetBuilder.buildPngFile(context: context, content: content);
      } catch (e) {
        debugPrint('[InstagramShare] buildPngFile threw: $e');
        // pngFile stays null → falls through to text-only fallback below.
      }

      if (pngFile == null) {
        await Share.share(
          shareText,
          subject: shareSubject,
          sharePositionOrigin: sharePositionOrigin,
        );
        return StoriesShareOutcome.fallback;
      }

      final xFile = XFile(pngFile.path, mimeType: 'image/png', name: 'openwhen_story.png');

      // ---------- 2. Try native Instagram Stories ----------
      if (!kIsWeb && kFacebookAppIdConfigured && (Platform.isIOS || Platform.isAndroid)) {
        final available = await InstagramStoriesPlatform.isInstagramStoryAvailable();
        if (available) {
          try {
            await InstagramStoriesPlatform.shareInstagramStory(
              backgroundPath: pngFile.path,
              facebookAppId: kFacebookAppId,
            ).timeout(const Duration(seconds: 30));
            return StoriesShareOutcome.nativeOpened;
          } catch (e) {
            debugPrint('[InstagramShare] native share failed: $e');
            // Fall through to share-sheet fallback with image.
          }
        }
      }

      // ---------- 3. Fallback: share sheet with image ----------
      await _shareFiles(
        files: [xFile],
        text: shareText,
        subject: shareSubject,
        origin: sharePositionOrigin,
      );
      return StoriesShareOutcome.fallback;
    } catch (e) {
      // ---------- 4. Ultimate safety net: text-only share ----------
      debugPrint('[InstagramShare] unexpected error, text-only fallback: $e');
      try {
        await Share.share(
          shareText,
          subject: shareSubject,
          sharePositionOrigin: sharePositionOrigin,
        );
      } catch (_) {}
      return StoriesShareOutcome.fallback;
    } finally {
      if (pngFile != null) {
        try {
          if (await pngFile.exists()) await pngFile.delete();
        } catch (_) {}
      }
    }
  }

  static Future<void> _shareFiles({
    required List<XFile> files,
    required String text,
    required String subject,
    Rect? origin,
  }) async {
    await Share.shareXFiles(
      files,
      text: text,
      subject: subject,
      sharePositionOrigin: origin,
    );
  }
}
