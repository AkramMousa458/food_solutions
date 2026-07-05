import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_solutions/core/router/app_router.dart';
import 'package:food_solutions/features/base/presentation/screens/base_screen.dart';

/// Handles FCM in all app states: foreground, background, and terminated.
///
/// Usage:
/// ```dart
/// await PushNotificationService.instance.initialize();
/// ```
class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  static const String channelId = 'food_solutions_high_importance';
  static const String channelName = 'Food Solutions notifications';
  static const String channelDescription = 'Food Solutions notifications';
  static const String allUsersTopic = 'all_users';

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Map<String, dynamic>? _pendingNavigationData;

  /// Latest FCM registration token (updated on refresh).
  String? fcmToken;

  /// Called when FCM issues a new registration token.
  void Function(String token)? onFcmTokenRefreshed;

  /// Called when the user opens a notification (tap), with payload data.
  void Function(Map<String, dynamic> data)? onNotificationOpened;

  /// Initializes permissions, local notifications, FCM listeners, and cold-start tap.
  Future<void> initialize() async {
    if (_initialized) return;

    await _requestPermissions();
    await _initLocalNotifications();
    await _createAndroidChannel();
    _registerForegroundListeners();
    await _handleInitialMessage();
    await _refreshToken();

    _messaging.onTokenRefresh.listen((token) {
      fcmToken = token;
      log('FCM token refreshed: $token');
      onFcmTokenRefreshed?.call(token);
    });

    _initialized = true;
    log('PushNotificationService initialized');
  }

  /// Handles data-only messages in the background isolate (notification payload
  /// is already shown by the OS).
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    log('Background FCM: ${message.messageId}');
    if (message.notification != null) return;

    final service = PushNotificationService.instance;
    await service._initLocalNotifications();
    await service._createAndroidChannel();
    await service._showLocalNotification(message);
  }

  Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    log('FCM permission: ${settings.authorizationStatus}');

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final android = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await android?.requestNotificationsPermission();
    }
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _localNotifications.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onLocalNotificationTapped,
    );
  }

  Future<void> _createAndroidChannel() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    const channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
    );

    final android = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.createNotificationChannel(channel);
  }

  void _registerForegroundListeners() {
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  Future<void> _handleInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      _dispatchOpenedNotification(message, defer: true);
    }
  }

  /// Processes a notification tap that arrived before the router was ready.
  void handlePendingNotificationNavigation() {
    final data = _pendingNavigationData;
    if (data == null) return;
    _pendingNavigationData = null;
    _navigateFromData(data);
  }

  Future<void> _refreshToken() async {
    fcmToken = await getFcmToken();
    log('FCM token: $fcmToken');
  }

  /// Returns the current FCM registration token, fetching it if needed.
  Future<String?> getFcmToken() async {
    try {
      fcmToken = await _messaging.getToken();
      return fcmToken;
    } catch (e, st) {
      log('Failed to get FCM token', error: e, stackTrace: st);
      return null;
    }
  }

  /// Subscribes this device to an FCM topic (e.g. broadcast notifications).
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      log('Subscribed to FCM topic: $topic');
    } catch (e, st) {
      log('Failed to subscribe to FCM topic: $topic', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    log('Foreground FCM: ${message.messageId}');
    await _showLocalNotification(message);
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    log('Opened from background FCM: ${message.messageId}');
    _dispatchOpenedNotification(message);
  }

  void _onLocalNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) {
      _navigateFromData({});
      return;
    }
    _navigateFromData(_decodePayload(payload));
  }

  void _dispatchOpenedNotification(
    RemoteMessage message, {
    bool defer = false,
  }) {
    final data = Map<String, dynamic>.from(message.data);
    onNotificationOpened?.call(data);
    if (defer) {
      _pendingNavigationData = data;
      return;
    }
    _navigateFromData(data);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final (title, body) = _titleAndBody(message);
    if (title.isEmpty && body.isEmpty) return;

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _localNotifications.show(
      id: _notificationId(message),
      title: title.isNotEmpty ? title : 'Food Solutions',
      body: body,
      notificationDetails: NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: _encodePayload(message.data),
    );
  }

  (String title, String body) _titleAndBody(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      return (notification.title ?? '', notification.body ?? '');
    }

    return (
      message.data['title']?.toString() ?? '',
      message.data['body']?.toString() ??
          message.data['message']?.toString() ??
          '',
    );
  }

  int _notificationId(RemoteMessage message) {
    final id = message.messageId;
    if (id != null) return id.hashCode;
    return DateTime.now().millisecondsSinceEpoch.remainder(1 << 31);
  }

  String? _encodePayload(Map<String, dynamic> data) {
    if (data.isEmpty) return null;
    return data.entries.map((e) => '${e.key}=${e.value}').join('&');
  }

  Map<String, dynamic> _decodePayload(String payload) {
    final map = <String, dynamic>{};
    for (final part in payload.split('&')) {
      final separatorIndex = part.indexOf('=');
      if (separatorIndex > 0) {
        map[part.substring(0, separatorIndex)] =
            part.substring(separatorIndex + 1);
      }
    }
    return map;
  }

  /// Maps notification routes to registered GoRouter paths.
  String? _resolveRoute(String? route) {
    if (route == null || route.isEmpty) return null;

    const aliases = <String, String>{
      '/home-screen': BaseScreen.routeName,
      '/home': BaseScreen.routeName,
    };

    return aliases[route] ?? route;
  }

  void _navigateFromData(Map<String, dynamic> data) {
    final route = _resolveRoute(data['route']?.toString());
    if (route != null && route.isNotEmpty) {
      try {
        AppRouter.router.go(route);
      } catch (e, st) {
        log('Notification navigation failed', error: e, stackTrace: st);
      }
      return;
    }

    try {
      AppRouter.router.go(BaseScreen.routeName);
    } catch (e, st) {
      log('Default notification navigation failed', error: e, stackTrace: st);
    }
  }
}
