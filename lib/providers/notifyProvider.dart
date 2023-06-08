import 'package:inventory_system/imports.dart';
import 'package:timezone/data/latest.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;

class NotifyProvider {
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;
  var _androidNotificationDetails;
  var _iosNotificationDetails;
  var platformChannelSpecifics;
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init(String image) async {
    _androidNotificationDetails = AndroidNotificationDetails(
      'channel ID',
      'channel name',
      channelDescription: 'channel description',
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
      icon: image,
      largeIcon: DrawableResourceAndroidBitmap(image),
    );

    _iosNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 1,
      attachments: null,
      subtitle: 'Subtitle',
      threadIdentifier: '1',
    );

    platformChannelSpecifics = NotificationDetails(
      android: _androidNotificationDetails,
      iOS: _iosNotificationDetails,
    );

    initializationSettingsAndroid = AndroidInitializationSettings(image);

    initializationSettingsIOS = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    tzData.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  var notificationIOS;
  var notificationAndroid;

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> showNotifications(
      String notificationTitle, String notificationBody) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      notificationTitle,
      notificationBody,
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }

  Future<void> scheduleNotifications(
      String notificationTitle, String notificationBody) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      notificationTitle,
      notificationBody,
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(1);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
