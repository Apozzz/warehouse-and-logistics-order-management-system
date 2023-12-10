import 'package:flutter/material.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/features/notification/DAOs/notification_dao.dart';
import 'package:inventory_system/features/notification/models/notification_model.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final NotificationDAO notificationDAO;
  late String _userId;
  late String _companyId;

  NotificationService({
    required BuildContext context,
    required this.notificationDAO,
  }) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final companyProvider =
        Provider.of<CompanyProvider>(context, listen: false);
    _userId = authViewModel.currentUser!.uid;
    _companyId = companyProvider.companyId!;

    initializeNotifications();
    tz.initializeTimeZones();
  }

  Future<void> initializeNotifications() async {
    if (!await hasExactAlarmPermission) {
      promptExactAlarmPermission();
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_icon');

    // The iOS and macOS initialization settings have been removed.
    // If needed, you should check the latest documentation on how to add them.

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Handler for when a notification is triggered while the app is in the foreground
  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    // Handle your logic here
  }

  /// Handler for when a notification is selected
  Future onSelectNotification(String? payload) async {
    // Handle your logic here
  }

  Future<void> showNotification(int id, String title, String body) async {
    var androidDetails = const AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'channelDescription',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    var platformDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
        id, title, body, platformDetails);

    // Create and save the notification model to the database
    var notification =
        _createNotificationModel(id, title, body, DateTime.now());
    await _saveNotification(notification);
  }

  Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    // Schedule the notification
    if (!await hasExactAlarmPermission) {
      promptExactAlarmPermission();
    }

    var scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);
    var androidDetails = const AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'channelDescription',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    // Create and save the notification model to the database with scheduled time
    var notification = _createNotificationModel(id, title, body, scheduledTime);
    await _saveNotification(notification);
  }

  NotificationModel _createNotificationModel(
      int id, String title, String body, DateTime scheduledTime) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      userId: _userId,
      companyId: _companyId,
      scheduledTime: scheduledTime,
    );
  }

  Future<void> _saveNotification(NotificationModel notification) async {
    await notificationDAO.createNotification(notification);
  }

  Future<bool> get hasExactAlarmPermission async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 31) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>();

        return await androidImplementation?.requestNotificationsPermission() ??
            false;
      }
    }
    // For iOS and lower versions of Android, return true as they do not need this permission.
    return true;
  }

  Future<void> promptExactAlarmPermission() async {
    if (await hasExactAlarmPermission == false) {
      // You can use a package like 'app_settings' to open the app settings page
      AppSettings.openAppSettings();
    }
  }
}
