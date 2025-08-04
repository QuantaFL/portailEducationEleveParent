import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

/// Service for handling local notifications in the app
class NotificationService extends GetxService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final Logger _logger = Logger();

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeNotifications();
  }

  /// Initialize local notifications
  Future<void> _initializeNotifications() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
          );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Request permissions for Android 13+
      if (Platform.isAndroid) {
        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
      }

      _logger.i('✅ Notification service initialized');
    } catch (e) {
      _logger.e('❌ Error initializing notifications: $e');
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    final payload = notificationResponse.payload;
    if (payload != null) {
      _logger.d('🔔 Notification tapped with payload: $payload');
      // Handle navigation based on payload if needed
    }
  }

  /// Show notification for new bulletin
  Future<void> showBulletinNotification({
    required String studentName,
    required String bulletinTitle,
    int? bulletinId,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'bulletins_channel',
            'Bulletins',
            channelDescription: 'Notifications pour nouveaux bulletins',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'Nouveau bulletin disponible',
            icon: '@mipmap/ic_launcher',
          );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await _flutterLocalNotificationsPlugin.show(
        bulletinId ?? DateTime.now().millisecondsSinceEpoch.remainder(100000),
        'Nouveau bulletin disponible',
        'Bulletin de $studentName: $bulletinTitle',
        platformChannelSpecifics,
        payload: bulletinId?.toString(),
      );

      _logger.i('✅ Bulletin notification sent for $studentName');
    } catch (e) {
      _logger.e('❌ Error showing bulletin notification: $e');
    }
  }

  /// Show general notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'general_channel',
            'Général',
            channelDescription: 'Notifications générales',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails();

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );

      _logger.i('✅ General notification sent: $title');
    } catch (e) {
      _logger.e('❌ Error showing notification: $e');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    _logger.i('✅ All notifications cancelled');
  }
}
