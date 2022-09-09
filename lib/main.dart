import 'package:flutter/material.dart';
import 'screens/signin.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gluc-Safe",
      initialRoute: '/',
      routes: {
        '/': (context) => const SignInPage(),
      },
    ),
  );
}
