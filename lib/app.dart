import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gluc_safe/screens/mainPage/MainPage.dart';
import 'screens/screens.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: "Gluc-Safe",
      initialRoute: '/',
      routes: {
        '/': (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  if (snapshot.data!.displayName == null) {
                    return const UserDetails();
                  } else if (!snapshot.data!.emailVerified)
                    return const LoginPage();
                  return const MainPage();
                } else if (snapshot.hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Some error occured")));
                }
                return const LoginPage();
              },
            ),
        '/register': (context) => const RegisterPage(),
        '/details': (context) => const UserDetails(),
        '/chart': (context) => const ChartPage(),
      },
    );
  }
}
