import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as dev;

class NotificationHandler {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> requestPermission() async {
    // Request permission to receive notifications on the device
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
    );
  }

  static createChannel() async {
    const MethodChannel _channel =
        MethodChannel('glucsafe.com/medication-reminders');
    Map<String, String> channelMap = {
      'id': 'gluc-safe-notification',
      'name': 'Gluc Safe Medications',
      'description': 'Gluc Safe Medications Reminders Notifications',
    };

    try {
      await _channel.invokeMethod('createNotificationChannel', channelMap);
    } on PlatformException catch (e) {
      dev.log(e.toString());
    }
  }
}
