import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/widgets/valuePicker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceWidth, _deviceHeight;

  final firebaseUser = FirebaseAuth.instance.currentUser;
  final userCollection = DatabaseService.users;
  final userGlucCollection = DatabaseService.usersGlucose;
  late final databaseService;
  var glucUser, glucUserData;

  double? glucoseValue = 100;

  @override
  void initState() {
    databaseService = DatabaseService(uid: firebaseUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: homeAppBar(),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: topContainer(),
          ),
          Expanded(
            flex: 2,
            child: bottomContainer(),
          ),
        ],
      ),
    );
  }

  Widget bottomContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        glucoseValuePicker(),
        glucoseSaveButton(),
      ],
    );
  }

  Widget glucoseSaveButton() {
    return ElevatedButton(
      onPressed: () {
        databaseService.updateUserGlucose(glucoseValue, glucUser['fullName']);
        print("Saving Value: $glucoseValue for ${glucUser['fullName']}");
      },
      child: const Text("Save Value"),
    );
  }

  Widget topContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        roundedContainer("Previous Glucose value"),
        roundedContainer("Average Glucose value")
      ],
    );
  }

  Widget roundedContainer(String text) {
    return Container(
      width: _deviceWidth * 0.46,
      height: _deviceHeight * 0.1,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            text,
            style: textTitleStyle(16, Colors.white),
          ),
          const Text("Glucose Value") // TODO!!
        ],
      ),
    );
  }

  TextStyle textTitleStyle(double fontsize, Color color) {
    return TextStyle(
      fontSize: fontsize,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }

  FutureBuilder<dynamic> appbarTitle() {
    return FutureBuilder(
        future: getUserName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map user = snapshot.data;
            return Text("Welcome ${user['fullName']}");
          }
          return const Text("Loading username...");
        });
  }

  AppBar homeAppBar() {
    return AppBar(
      backgroundColor: Colors.amber[500],
      title: appbarTitle(),
      elevation: 1.0,
      leading: IconButton(
        color: Color.fromRGBO(0, 0, 0, 1.0),
        iconSize: 30,
        splashRadius: 25,
        icon: const Icon(Icons.person),
        onPressed: () {
          Navigator.pushNamed(context, '/profile');
        },
      ),
      actions: [
        signOutButton(),
      ],
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

  Future getUserName() async {
    var user = await userCollection.doc(firebaseUser!.uid).get();
    return user.data() as Map;
  }
}
