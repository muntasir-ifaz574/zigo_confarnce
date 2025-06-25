// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
//
// class LocalNotificationService {
//   static final LocalNotificationService _localNotificationService =
//   LocalNotificationService._internal();
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   LocalNotificationService._internal();
//
//   factory LocalNotificationService() {
//     return _localNotificationService;
//   }
//
//   Future<void> init() async {
//     const AndroidInitializationSettings initSettingAndroid = AndroidInitializationSettings('app_icon');
//
//     const DarwinInitializationSettings initSettingIOS = DarwinInitializationSettings(
//       requestSoundPermission: false,
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//     );
//
//     const InitializationSettings initializationSettings =
//     InitializationSettings(
//       android: initSettingAndroid,
//       iOS: initSettingIOS,
//     );
//
//     tz.initializeTimeZones();
//
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         await onSelectNotification(response.payload);
//       },
//     );
//   }
//
//   Future onSelectNotification(String? payload) async {
//
//   }
// }