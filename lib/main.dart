import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/services/database.dart';
import 'screens/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp()
      : await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyDSjYnrijImtCx-Cd_cUURGa3w3atKTi_c",
              authDomain: "gluc-safe.firebaseapp.com",
              projectId: "gluc-safe",
              storageBucket: "gluc-safe.appspot.com",
              messagingSenderId: "463867324918",
              appId: "1:463867324918:web:6e8aa52917e5f2bae3bfd7"));
  GetIt.instance.registerSingleton<FirebaseService>(FirebaseService());
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gluc-S afe",
      initialRoute: '/',
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
                return const FirstPage();
              },
            ),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/details': (context) => const UserDetails(),
      },
    ),
  );
}
