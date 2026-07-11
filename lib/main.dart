import 'package:apod/services/notification_service.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.scheduleDailyNotification(
      title: "New Space Picture!",
      body: "Check out today's Astronomy Picture of the Day",
      hour: 9,
      minute: 0,
  );
  
  runApp(const Apod());
}