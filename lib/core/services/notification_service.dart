import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../firebase_options.dart';
import 'fcm_token_manager.dart';

final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
  'openwhen_default',
  'OpenWhen',
  description: 'Notificações do OpenWhen',
  importance: Importance.high,
);

/// Handler em isolate separado (obrigatório para mensagens em background).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class NotificationService {
  NotificationService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await _setupLocalNotifications();
    }

    try {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (_) {}

    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      if (kDebugMode) {
        debugPrint('FCM permission: ${settings.authorizationStatus}');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('FCM requestPermission: $e');
    }

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (kDebugMode) debugPrint('Opened from notification: ${message.messageId}');
    });

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) return;
      await _syncTokenForCurrentUser();
    });

    await syncPushToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      await FcmTokenManager.saveToken(token);
    });
  }

  /// Solicita permissão novamente e grava o token no Firestore (ex.: após ajustes nas configurações).
  static Future<void> requestPermissionAndSync() async {
    try {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
    } catch (_) {}
    await syncPushToken();
  }

  static Future<void> syncPushToken() async => _syncTokenForCurrentUser();

  static Future<void> _setupLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      ),
    );

    final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_androidChannel);
  }

  /// iOS: FCM só retorna um token depois que o APNs device token existe (assíncrono).
  static Future<void> _waitForIosApnsToken() async {
    if (!Platform.isIOS) return;
    for (var i = 0; i < 30; i++) {
      final apns = await _messaging.getAPNSToken();
      if (apns != null) return;
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
  }

  static Future<void> _syncTokenForCurrentUser() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    try {
      await _waitForIosApnsToken();
      final token = await _messaging.getToken();
      if (token != null) await FcmTokenManager.saveToken(token);
    } catch (e) {
      if (kDebugMode) debugPrint('FCM getToken: $e');
    }
  }

  static Future<void> _onForegroundMessage(RemoteMessage message) async {
    if (kIsWeb) return;

    final notification = message.notification;
    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();
    if (title == null && body == null) return;

    if (Platform.isAndroid) {
      await _localNotifications.show(
        id: message.hashCode,
        title: title ?? 'OpenWhen',
        body: body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
    // iOS: apresentação em foreground via setForegroundNotificationPresentationOptions
  }
}
