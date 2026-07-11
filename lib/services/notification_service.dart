import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) return;
    tz.initializeTimeZones();

    const initAndroidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initIosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const initSettings = InitializationSettings(
      android: initAndroidSettings,
      iOS: initIosSettings,
    );

    await notificationsPlugin.initialize(settings: initSettings);
    _isInitialized = true;
  }

  NotificationDetails notificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      'apod_channel',
      'APOD Notifications',
      channelDescription: 'Notifications for Astronomy Picture of the Day',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    return NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  Future<void> scheduleDailyNotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
})async{
    if(!_isInitialized) await init();
    await notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate:  _nextInstanceOfTime(hour, minute),
        notificationDetails:  notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute){
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if(scheduledDate.isBefore(now)){
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
