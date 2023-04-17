import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/app.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as dev;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.request();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  GetIt.instance.registerSingleton<FirebaseService>(FirebaseService());
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      dev.log('connected');
    }
  } on SocketException catch (_) {
    dev.log('not connected');
  }
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('he')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}
