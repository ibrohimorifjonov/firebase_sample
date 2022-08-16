import 'dart:io';

import 'package:firebase_sample/data/data_source/local_source.dart';
import 'package:firebase_sample/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
  'notification',
  'Application received',
  description:
      'THis channel is used for showing notifications about applications',
  importance: Importance.max,
);

class NotificationsService {
  NotificationsService._();

  static Future<void> initialize() async {
    await Firebase.initializeApp();
    try {
      String token = await FirebaseMessaging.instance.getToken() ?? '';
      await LocalSource.getInstance().setFcmToken(token);
      debugPrint("FCM_TOKEN: $token");
    } catch (e) {
      debugPrint("Exception $e");
    }
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    AndroidInitializationSettings androidNotificationSettings =
        const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidNotificationSettings,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) {
        debugPrint('================== = $payload');
        if (payload == Routes.main) {
          Get.toNamed(Routes.main);
        } else {
          Get.toNamed(Routes.home);
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
      (remoteMessage) async {
        debugPrint("TTT : onMessage");
        final Map<String, dynamic> data = remoteMessage.data;
        if (Platform.isAndroid) {
          flutterLocalNotificationsPlugin.show(
            remoteMessage.hashCode,
            data["title"],
            data["body"],
            NotificationDetails(
              android: AndroidNotificationDetails(
                androidChannel.id,
                androidChannel.name,
                channelDescription: androidChannel.description,
                playSound: true,
                channelShowBadge: false,
                importance: Importance.max,
                fullScreenIntent: false,
                icon: '@mipmap/ic_launcher',
                priority: Priority.high,
                showWhen: true,
                visibility: NotificationVisibility.private,
              ),
              iOS: const IOSNotificationDetails(
                presentSound: true,
                presentAlert: true,
                presentBadge: true,
                sound: 'default',
              ),
            ),
            payload: data['screen'],
          );
        }
      },
    );

    /// data jo'natish uchun kerak
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(
      (remoteMessage) async {
        debugPrint("TTT: onMessageOpenedApp");
        debugPrint('***************** = ${remoteMessage.data['screen']}');
        if (remoteMessage.data['screen'] == Routes.main) {
          Get.toNamed(Routes.main);
        } else {
          Get.toNamed(Routes.home);
        }
      },
    );
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.data["title"],
      message.data["body"],
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidChannel.id,
          androidChannel.name,
          channelDescription: androidChannel.description,
          playSound: true,
          channelShowBadge: false,
          importance: Importance.max,
          fullScreenIntent: false,
          icon: '@mipmap/ic_launcher',
          priority: Priority.high,
          showWhen: true,
          visibility: NotificationVisibility.private,
        ),
        iOS: const IOSNotificationDetails(
          presentSound: true,
          presentAlert: true,
          presentBadge: true,
          sound: 'default',
        ),
      ),
      payload: message.data['screen'],
    );

    debugPrint("Handling a background message: ${message.messageId}");
  }
}
