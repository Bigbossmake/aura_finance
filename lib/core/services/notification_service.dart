import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes timezone data and native local notification settings
  static Future<void> init() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    
    await _notificationsPlugin.initialize(initializationSettings);
  }

  /// Request permissions for showing alerts (Android 13+ & iOS)
  static Future<void> requestPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
        
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// Schedules a push notification warning 3 days before the subscription billing date.
  /// For testing/demonstration, if the 3-day reminder is in the past, it schedules it for 5 seconds from now.
  static Future<void> scheduleSubscriptionReminder({
    required String id,
    required String subscriptionName,
    required double amount,
    required String currency,
    required DateTime billingDate,
  }) async {
    final reminderDate = billingDate.subtract(const Duration(days: 3));
    
    // If the reminder date is in the past, schedule it for 5 seconds in the future (for demo purposes)
    final scheduleTime = reminderDate.isBefore(DateTime.now())
        ? DateTime.now().add(const Duration(seconds: 5))
        : reminderDate;

    await _notificationsPlugin.zonedSchedule(
      id.hashCode,
      'Upcoming Renewal: $subscriptionName',
      'Your subscription to $subscriptionName ($amount $currency) will renew in 3 days. Tap to cancel if you don\'t use it.',
      tz.TZDateTime.from(scheduleTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'subscription_alerts',
          'Subscription Alerts',
          channelDescription: 'Alerts for upcoming subscription renewals to avoid extra charges',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Cancels a scheduled subscription reminder notification.
  static Future<void> cancelSubscriptionReminder(String id) async {
    await _notificationsPlugin.cancel(id.hashCode);
  }
}
