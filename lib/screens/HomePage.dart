import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gluc_safe/services/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceWidth, _deviceHeight;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  late final glucUser;
  final userCollection = DatabaseService.users;

  @override
  void initState() {
    glucUser = userCollection.where("uid", isEqualTo: firebaseUser!.uid).get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gluc Safe"),
        centerTitle: true,
        backgroundColor: Colors.amber[800],
        actions: [
          signOutButton(),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: topContainer(),
          ),
          Flexible(
            flex: 5,
            child: Container(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget topContainer() {
    //String fullName = glucUser["fullName"];
    return Container(
      width: _deviceWidth,
      color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [const Text("Gluc-Safe Home"), Text("Welcome")],
      ),
    );
  }

  TextButton signOutButton() {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
      onPressed: () {
        FirebaseAuth.instance.signOut();
      },
      child: const Text(
        "Sign Out",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
