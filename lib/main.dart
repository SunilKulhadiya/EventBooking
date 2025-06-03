// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goevent2/langauge_translate.dart';
import 'package:goevent2/spleshscreen.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:provider/provider.dart';
import 'agent_chat_screen/chat_screen.dart';
import 'firebase_options.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  print("21 main.dart, DefaultFirebaseOptions.currentPlatform : ${DefaultFirebaseOptions.currentPlatform}");

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print("Firebase already initialized: $e");
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await permissionLocation();
  await requestPermission();
  listenFCM();
  await loadFCM();
  await initializeNotifications();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ColorNotifire())],
      child: GetMaterialApp(
        translations: LocaleString(),
        locale: const Locale('en_US', 'en_US'),
        title: 'Event Management'.tr,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          dividerColor: Colors.transparent,
          fontFamily: "Gilroy",
        ),
        home: const Directionality(
          textDirection: TextDirection.ltr,
          child: Spleshscreen(),
        ),
      ),
    ),
  );
}


// ✅ Background FCM handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }
  } catch (e) {
    print("Background handler Firebase init error: $e");
  }

  // You can handle background message data here
}

// ✅ Request notification permissions
Future<void> requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

// ✅ Foreground FCM listener
void listenFCM() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
            presentBadge: true,
          ),
        ),
        payload: jsonEncode({
          "name": message.data["name"],
          "id": message.data["id"],
          "propic": message.data["propic"],
        }),
      );
    }
  });
}

// ✅ Initialize local notifications
Future<void> initializeNotifications() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (response.payload != null) {
        final data = jsonDecode(response.payload!);
        Get.to(() => ChatPage(
          proPic: data["propic"],
          resiverUserId: data["id"],
          resiverUseremail: data["name"],
        ));
      }
    },
  );
}

// ✅ Create notification channel & foreground options
Future<void> loadFCM() async {
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      enableVibration: true,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
