import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/Models/user.dart';
import 'dart:developer' as dev;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceWidth, _deviceHeight;
  FirebaseService? _firebaseService;
  GlucUser? _glucUser;
  double? glucoseValue = 100;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    getGlucUser();
  }

  Future<GlucUser> getGlucUser() async {
    String uid = _firebaseService!.user.uid;
    Map userData = await _firebaseService!.getUserData(uid: uid) as Map;
    var timestamp = userData['birthdate'].seconds;
    DateTime birthDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    GlucUser user = GlucUser(
        userData['firstName'],
        userData['lastName'],
        birthDate,
        180,
        userData['gender'],
        userData['mobile'],
        userData['contactName'],
        userData['contactNumber']);
    _glucUser = user;
    return user;
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: homeAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add,
          size: 38,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.redAccent,
        shape: const CircularNotchedRectangle(),
        notchMargin: 3,
        child: bottomNavBar(),
      ),
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

  Widget bottomNavBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.forum, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/profile', arguments: _glucUser);
          },
          icon: const Icon(Icons.person, color: Colors.white),
        )
      ],
    );
  }

  Widget bottomContainer() {
    return Container(
      color: Colors.green,
      width: _deviceWidth,
      child: const Center(
        child: Text(
          "Bottom Container",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget topContainer() {
    return Container(
      color: Colors.blue,
      child: const Center(
        child: Text(
          "Top Container",
          style: TextStyle(fontSize: 20),
        ),
      ),
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

  AppBar homeAppBar() {
    return AppBar(
      backgroundColor: Colors.amber[500],
      title: FutureBuilder(
        future: getGlucUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            GlucUser user = snapshot.data as GlucUser;
            return Text(
              "Hello ${user.firstName}",
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.w300,
                fontFamily: "BebasNeue",
                letterSpacing: 1,
              ),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
      elevation: 1.0,
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
        _firebaseService!.logout();
      },
      child: const Text(
        "Sign Out",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
