import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/services/database.dart';
import 'firebase_options.dart';
import 'screens/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  GetIt.instance.registerSingleton<FirebaseService>(FirebaseService());
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gluc-Safe",
      initialRoute: '/chart',
      routes: {
        '/': (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  return const HomePage();
                } else if (snapshot.hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Some error occured")));
                }
                return const LoginPage();
              },
            ),
        '/register': (context) => const RegisterPage(),
        '/details': (context) => const UserDetails(),
        '/profile': (context) => ProfilePage(),
        '/chart': (context) => const ChartPage()
      },
    ),
  );
}
