import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Native Instagram Stories (Meta Sharing to Stories). See `FB_APP_ID` in [facebook_app_config.dart].
class InstagramStoriesPlatform {
  InstagramStoriesPlatform._();

  static const MethodChannel _channel = MethodChannel('com.openwhen.app/instagram_stories');

  static Future<bool> isInstagramStoryAvailable() async {
    if (kIsWeb) return false;
    if (!Platform.isIOS && !Platform.isAndroid) return false;
    try {
      final v = await _channel.invokeMethod<bool>('isInstagramStoryAvailable');
      return v ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> shareInstagramStory({
    required String backgroundPath,
    required String facebookAppId,
  }) async {
    await _channel.invokeMethod<void>('shareInstagramStory', <String, dynamic>{
      'backgroundPath': backgroundPath,
      'facebookAppId': facebookAppId,
    });
  }
}
