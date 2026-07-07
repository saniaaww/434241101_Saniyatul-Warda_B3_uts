import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings android =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: android);

    await flutterLocalNotificationsPlugin.initialize(settings);

    final androidPlugin =
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();

    _initialized = true;
  }

  static Future<void> showNotification({
    required int ticketId,
    required String title,
    required String body,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'ticket_channel',
        'Ticket Notification',
        channelDescription: 'Notifikasi Ticket',
        importance: Importance.max,
        priority: Priority.high,
      );

      await flutterLocalNotificationsPlugin.show(
        ticketId,
        title,
        body,
        const NotificationDetails(
          android: androidDetails,
        ),
      );
    } catch (e) {
      debugPrint("LOCAL NOTIFICATION ERROR: $e");
    }
  }
}