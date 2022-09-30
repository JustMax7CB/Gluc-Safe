import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gluc_safe/screens/loggedin.dart';
import 'package:gluc_safe/screens/signup.dart';
import 'screens/signin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gluc-Safe",
      initialRoute: '/',
      routes: {
        '/': (context) => StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const LoggedIn();
              } else if (snapshot.hasError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Some error occured")));
              }
              return const SignInPage();
            }),
        '/register': (context) => SignUpPage()
      },
    ),
  );
}
