// import 'dart:convert';

// import 'package:ahzir/firebase_options.dart';
// import 'package:ahzir/models/model/notification_model.dart';
// import 'package:ahzir/pages/bottom_nav_pages.dart';
// import 'package:ahzir/pages/match/daily_challenges.dart';
// import 'package:ahzir/screens/next_screens.dart';
// import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
// FlutterSecureStorage prefs = const FlutterSecureStorage();

// Future<void> showNotification(String title, String body, String image) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'ihzar',
//     'your channel name',
//     channelDescription: 'your channel description',
//     importance: Importance.max,
//     priority: Priority.high,
//     icon: '@mipmap/ic_launcher',

//     // showWhen: false,
//   );

//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//     0, // id
//     title, // title
//     body, // body
//     platformChannelSpecifics,
//     payload: 'custom_payload',
//   );
// }

// void _showNotificationWithoutImage(
//     String title, String body, String? payload) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'your_channel_id',
//     'your_channel_name',
//     channelDescription: 'your_channel_description',
//   );

//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);

//   await flutterLocalNotificationsPlugin.show(
//     0, // notification id
//     title,
//     body,
//     platformChannelSpecifics,
//     payload: payload,
//   );
// }

// // late SharedPreferences prefrs;
// FlutterSecureStorage storage = const FlutterSecureStorage();
// // TODO: Set up background message handler
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   // prefrs = await SharedPreferences.getInstance();
//   // Retrieve the existing list from SharedPreferences
//   // if(message.data['articleSlug'] != null) {
//   debugPrint('firebase messaging background handler');
//   String? storedData = await storage.read(key: 'notificationsList');
//   // If the stored data is not null, decode it into a List, otherwise return an empty list.
//   List myList = storedData != null ? jsonDecode(storedData) : [];
//   NotificationModel notification = NotificationModel(
//     title: message.notification?.title,
//     body: message.notification?.body,
//     // slug: message.data['articleSlug'],
//   );

//   // Convert the NotificationModel object to a map using toJson()
//   Map<String, dynamic> notificationMap = notification.toJson();
//   // Convert the NotificationModel object to a string using jsonEncode
//   String notificationString = jsonEncode(notificationMap);
//   // Add a new value to the list
//   myList.add(notificationString);
//   // If the list exceeds the maximum size, remove the oldest item
//   if (myList.length > 10) {
//     myList.removeAt(0);
//   }
//   storage.write(key: "notificationsList", value: jsonEncode(myList));
//   // }
//   // if(message.data['email'] != null){
//   //   prefrs.setString("userEmailRegistration", message.data['email']);
//   // }
// }

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// // firebase setup project
// firebaseSetup() async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   await messaging.getAPNSToken();
//   await messaging.requestPermission();
//   // Obtain the FCM token
//   String? fcmToken = await messaging.getToken();
//   debugPrint("FCM Token: $fcmToken");
//   prefs.write(key: "fcmtoken", value: "$fcmToken");

//   if (!kIsWeb) {
//     messaging.subscribeToTopic('all');
//   } else {
//     print('⚠️ Skipping topic subscription — not supported on web.');
//   }

//   // Initialize the FlutterLocalNotificationsPlugin
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings(
//           '@mipmap/ic_launcher'); // Replace with your app icon name

//   const initializationSettingsIOS = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true);

//   const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) {
//       // debugPrint("notification responseeee: ${response.payload}");
//       //when app is opened
//       if (response.payload != null) {
//         Map<String, dynamic> payloadMap = jsonDecode(response.payload!);
//         if (payloadMap['isMatchFinalResult'] == 'true') {
//           navigatorKey.currentState?.pushAndRemoveUntil(
//               MaterialPageRoute(builder: (context) => BottomNavPages(index: 2)),
//               (route) => false);
//         } else if (payloadMap.containsKey('dailymatches') &&
//             payloadMap['dailymatches'] == 'true') {
//           navigatorKey.currentState?.push(
//               PageRouteBuilder(pageBuilder: (_, __, ___) => DailyChallenges()));
//         }
//       }
//     },
//     // onDidReceiveBackgroundNotificationResponse: (NotificationResponse response) {
//     //   receiveNotification(response);
//     // },
//   );

//   // Handle incoming background messages
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//     //when app is on background
//     debugPrint("message recieved new");
//     //TODO Navigate to the desired page when clicking on notification

//     final notification = message.notification;
//     final data = message.data;
//     final payload = message.data;

//     if (notification != null) {
//       //&& data.isNotEmpty) {
//       String? title = notification.title;
//       String? body = notification.body;
//       final imageUrl = data['image'];

//       if (imageUrl != null) {
//         showNotification(title ?? '', body ?? '', imageUrl);
//       }
//       // else {
//       //   String? payloadString = jsonEncode(payload);
//       //   _showNotificationWithoutImage(title ?? '', body ?? '', payloadString);
//       // }
//     }

//     // if(message.data['articleSlug'] != null) {
//     String? storedData = await storage.read(key: 'notificationsList');
//     // If the stored data is not null, decode it into a List, otherwise return an empty list.
//     List myList = storedData != null ? jsonDecode(storedData) : [];
//     NotificationModel ntf = NotificationModel(
//       title: message.notification?.title,
//       body: message.notification?.body,
//       // slug: message.data['articleSlug'],
//     );

//     // Convert the NotificationModel object to a map using toJson()
//     Map<String, dynamic> notificationMap = ntf.toJson();
//     // Convert the NotificationModel object to a string using jsonEncode
//     String notificationString = jsonEncode(notificationMap);
//     // Add a new value to the list
//     myList.add(notificationString);
//     // If the list exceeds the maximum size, remove the oldest item
//     if (myList.length > 10) {
//       myList.removeAt(0);
//     }
//     storage.write(key: "notificationsList", value: jsonEncode(myList));
//     // }
//   });

//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     // debugPrint("notification responseeee on message openedd: ${message.data}");
//     // Retrieve the data from the notification

//     if (message.data['isMatchFinalResult'] == 'true') {
//       navigatorKey.currentState?.pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => BottomNavPages(index: 2)),
//           (route) => false);
//     } else if (message.data.containsKey('dailymatches') &&
//         message.data['dailymatches'] == 'true') {
//       navigatorKey.currentState?.push(
//           PageRouteBuilder(pageBuilder: (_, __, ___) => DailyChallenges()));
//     }

//     // Extract the necessary data from the message
//     // final notification = message.notification;
//     // final payload = message.data;
//     //TODO Navigate to the desired page using the navigatorKey
//   });

//   // Handle incoming background messages
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
// }

// // when app is terminated or closed
// // and we receive a notification so that we can redirect it
// Future<bool> setupInteractMessage() async {
//   bool containNotificationNavigation = false;
//   // when app is terminated
//   RemoteMessage? initialMessage =
//       await FirebaseMessaging.instance.getInitialMessage();

//   // debugPrint("setupinteractmessage: $initialMessage");
//   if (initialMessage != null) {
//     containNotificationNavigation =
//         handleMessage(navigatorKey.currentContext!, initialMessage);
//   }
//   return containNotificationNavigation;
// }

// bool handleMessage(BuildContext context, RemoteMessage? message) {
//   // debugPrint("handle message: ${message?.data}");
//   if (message?.data != null) {
//     Map<String, dynamic> payloadMap = message!.data;
//     if (payloadMap['isMatchFinalResult'] == 'true') {
//       navigatorKey.currentState?.pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => BottomNavPages(index: 2)),
//           (route) => false);
//       return true;
//     }
//   }
//   return false;
// }
