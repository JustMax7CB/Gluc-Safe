import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/screens/screens.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/Models/user.dart';
import 'dart:developer' as dev;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late double _deviceWidth, _deviceHeight;
  FirebaseService? _firebaseService;
  GlucUser? _glucUser;
  int _pageIndex = 0;
  PageController _pageController = PageController();
  GlucUser nullUser = GlucUser("", "", DateTime.now(), 0, "", "", "", "");

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    getGlucUser();
  }

  Future<GlucUser> getGlucUser() async {
    String uid = _firebaseService!.user.uid;
    Map userData = await _firebaseService!.getUserData() as Map;
    var timestamp = userData['birthdate'].seconds;
    DateTime birthDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    GlucUser user = GlucUser(
        userData['firstName'],
        userData['lastName'],
        birthDate,
        userData['height'],
        userData['gender'],
        userData['mobile'],
        userData['contactName'],
        userData['contactNumber']);
    _glucUser = user;
    return await user;
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: homeAppBar(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.redAccent,
        child: bottomNavBar(),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          HomePage(glucUser: _glucUser != null ? _glucUser! : nullUser),
          GlucosePage(),
          WorkoutPage(),
          WeightPage(),
          MedicationPage(),
        ],
        onPageChanged: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
      ),
    );
  }

  Widget bottomNavBar() {
    return Container(
      width: _deviceWidth,
      height: _deviceHeight * 0.07,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              _pageController.jumpToPage(0);
              _pageIndex = 0;
            },
            icon: const FaIcon(FontAwesomeIcons.vial),
            color: Colors.white,
            tooltip: "Glucose Page",
          ),
          IconButton(
            onPressed: () {
              _pageController.jumpToPage(1);
              _pageIndex = 1;
            },
            icon: const FaIcon(FontAwesomeIcons.dumbbell),
            color: Colors.white,
            tooltip: "Workout Page",
          ),
          IconButton(
            onPressed: () {
              _pageController.jumpToPage(2);
              _pageIndex = 2;
            },
            icon: const FaIcon(FontAwesomeIcons.weightScale),
            color: Colors.white,
            tooltip: "Medicine Page",
          ),
          IconButton(
            onPressed: () {
              _pageController.jumpToPage(3);
              _pageIndex = 3;
            },
            icon: const FaIcon(FontAwesomeIcons.capsules),
            color: Colors.white,
            tooltip: "Weight Page",
          ),
          IconButton(
            onPressed: () {
              // Navigator.pushNamed(context, '/profile', arguments: _glucUser);
              dev.log("${_glucUser!.contactName}, ${_glucUser!.contactNum}");
            },
            icon: const Icon(Icons.person, color: Colors.white),
            tooltip: "Profile Page",
          )
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
