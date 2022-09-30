import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoggedIn extends StatefulWidget {
  const LoggedIn({super.key});

  @override
  State<LoggedIn> createState() => _LoggedInState();
}

class _LoggedInState extends State<LoggedIn> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Gluc Safe"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Signed In as\n${user.email}!"),
            ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Text("Sign Out"))
          ],
        ),
      ),
    );
  }
}
