import 'package:bookish/data/notification_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:network_service/util/user_store.dart';

import '../firebase/firestore_util.dart';

class PushNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> setupInteractedMessage() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    enableIOSNotifications();
    await registerNotificationListeners();
  }

  Future<void> registerNotificationListeners() async {
    final AndroidNotificationChannel channel = androidNotificationChannel();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/logo');
    const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        final List<String> str =
            details.payload!.replaceAll('{', '').replaceAll('}', '').split(',');
        final Map<String, dynamic> result = <String, dynamic>{};
        for (int i = 0; i < str.length; i++) {
          final List<String> s = str[i].split(':');
          result.putIfAbsent(s[0].trim(), () => s[1].trim());
        }
        notificationRedirect(result);
      },
    );
    // onMessage is called when the app is in foreground and a notification is received
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      print("firebase_message: ${message?.data}");
      if (message != null) {
        _showNotification(message);
      }
      final RemoteNotification? notification = message!.notification;
      final AndroidNotification? android = message.notification?.android;
      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon,
            ),
          ),
          payload: message.data.toString(),
        );
      }
    });
  }

  Future<void> enableIOSNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  AndroidNotificationChannel androidNotificationChannel() => const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.', // description
        importance: Importance.max,
      );

  void notificationRedirect(Map<String, dynamic> result) {
    print("Notification redirection: ${result}");
  }

  _showNotification(RemoteMessage message) async {
    final AndroidNotificationChannel channel = androidNotificationChannel();
    final fireStoreUtil = new FireStoreUtil();
    var android = new AndroidNotificationDetails(channel.id, channel.name,
        priority: Priority.high, importance: Importance.max);
    // var iOS = new IOSNotificationDetails();
    final platform = new NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.show(
        0, message.data['title'], message.data['message'], platform,
        payload: message.data.toString());
    final userId = await UserStore.getUserId();
    final notificationInfo = NotificationInfo(
        title: message.data['title'],
        message: message.data['message'],
        deeplink: message.data['deeplinkUrl'],
        isRead: message.data['isRead'] == "true" ? true : false,
        createdAt: int.parse(message.data['createdAt']));
    fireStoreUtil.addNotification(userId, notificationInfo);
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  PushNotificationService()._showNotification(message);
}
