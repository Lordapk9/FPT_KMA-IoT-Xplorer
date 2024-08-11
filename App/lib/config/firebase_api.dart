import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:home_iot_device/main.dart';
import 'package:home_iot_device/screen/camera_door_check.dart';

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   print("Title: ${message.notification?.title}");
//   print("Body: ${message.notification?.body}");
//   print("Payload: ${message.data}");
//
// }

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChanel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Notification Push',
    description: "This is a channell push notification",
    importance: Importance.defaultImportance
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message){
    if(message == null){
      return;
    }
    navigatorKey.currentState?.pushNamed(
        CameraDoorCheck.route,
      arguments: message
    );
  }

  // Future initLocalNotifications() async {
  //
  //   const android = AndroidInitializationSettings("@drawable/ic_launcher");
  //   const setting = InitializationSettings(android: android, iOS: null);
  //
  //   await _localNotifications.initialize(
  //     setting,
  //     onDidReceiveNotificationResponse: (payload) {
  //       final message  = RemoteMessage.fromMap(jsonDecode(payload! as String));
  //       handleMessage(message);
  //     }
  //   );
  //   final platform = _localNotifications.resolvePlatformSpecificImplementation
  //     <AndroidFlutterLocalNotificationsPlugin>();
  //   await platform?.createNotificationChannel(_androidChanel);
  // }

//   Future initPushNotifications() async {
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//   alert: true,
//   badge: true,
//   sound: true
//   );
//   FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//   FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//   FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//   FirebaseMessaging.onMessage.listen((message) {
//     final notification =  message.notification;
//     if(notification == null) return;
//     _localNotifications.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           _androidChanel.id,
//           _androidChanel.name,
//           channelDescription: _androidChanel.description,
//           icon: '@drawable/ic_launcher'
//         )
//       ),
//       payload: jsonEncode(message.toMap())
//     );
//   });
// }
//
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    print("Token: ${fcmToken}");
    // initPushNotifications();
    // initLocalNotifications();
  }
}