import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gluc_safe/Models/glucose.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:gluc_safe/services/database.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late double _deviceWidth, _deviceHeight;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final userCollection = DatabaseService.users;
  final userGlucCollection = DatabaseService.usersGlucose;
  var glucUser, glucUserData;

  @override
  Widget build(BuildContext context) {
    bottomConatiner();
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Glucose test = Glucose(
              uid: firebaseUser!.uid, timeAdded: DateTime.now(), value: 561);
          saveUserGlucose(test);
        },
        backgroundColor: Colors.amber[500],
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 20,
        ),
      ),
      appBar: AppBar(
        title: const Text("Gluc Safe"),
        centerTitle: true,
        backgroundColor: Colors.amber[800],
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

  Future<DocumentSnapshot> getUser() async {
    var glucUser = await userCollection.doc(firebaseUser!.uid).get();
    return glucUser;
  }

  Future<DocumentSnapshot> getUserGluc() async {
    glucUserData = await userGlucCollection.doc(firebaseUser!.uid).get();
    return glucUserData;
  }

  TextStyle profileTextStyle() {
    return const TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
  }

  TextStyle profileTitleTextStyle() {
    return const TextStyle(fontSize: 24, fontWeight: FontWeight.w400);
  }

  Card profileCard(String title) {
    return Card(
      color: Colors.amber[200],
      elevation: 1,
      child: SizedBox(
        width: _deviceWidth * 0.25,
        height: _deviceHeight * 0.1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (title == "age")
                ? Text("Age", style: profileTitleTextStyle())
                : Text("Gender", style: profileTitleTextStyle()),
            FutureBuilder<DocumentSnapshot>(
              future: getUser(),
              builder: (context, snapshot) {
                GlucUser? user;
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  user = GlucUser(
                      uid: firebaseUser!.uid,
                      email: userData['email'],
                      pass: userData['pass'],
                      birth: userData['birthdate'].toDate(),
                      gender: userData['gender']);
                  if (title == "age") {
                    return Text(user.calcAge().toString());
                  } else {
                    return Text(user.gender);
                  }
                }
                return const Text("Loading...");
              },
            ),
          ],
        ),
      ),
    );
  }

  Future saveUserGlucose(Glucose glucRead) async {
    await DatabaseService(uid: glucRead.uid)
        .updateUserGlucose(glucRead.value, glucUser['fullName']);
  }

  Widget topContainer() {
    return SizedBox(
      width: _deviceWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FutureBuilder<DocumentSnapshot>(
              future: getUser(),
              builder: (context, snapshot) {
                GlucUser? user;
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  user = GlucUser(
                      uid: firebaseUser!.uid,
                      email: userData['email'],
                      pass: userData['pass'],
                      name: userData['fullName']);
                  return Text("Welcome ${user.fullName}",
                      style: profileTitleTextStyle());
                }
                return const Text("Loading name...");
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              profileCard('age'),
              profileCard('gender'),
            ],
          ),
        ],
      ),
    );
  }

  void bottomConatiner() async {
    var test;
    List<num> glucValues = [];
    test = await userGlucCollection.doc(firebaseUser!.uid).get();
    //print(test);
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
