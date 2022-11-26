import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/Models/enums/enumsExport.dart';
import 'package:gluc_safe/Models/glucose.dart';
import 'package:gluc_safe/Models/medications.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:gluc_safe/Models/weight.dart';
import 'package:gluc_safe/Models/workout.dart';
import 'package:gluc_safe/widgets/chart.dart';
import 'dart:developer' as dev;

import 'package:intl/intl.dart';

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
    Map userData = await _firebaseService!.getUserData() as Map;
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
          Expanded(
            flex: 2,
            child: workoutAndWeightContainer(),
          )
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

  Widget workoutAndWeightContainer() {
    return Container(
      color: Colors.yellow,
      width: _deviceWidth,
      child: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Workout workout = Workout(DateTime.now(), Workouts.Yoga, 60, 0);
                _firebaseService!.saveWorkoutData(workout);
              },
              child: const Text("Sport Update Test"),
            ),
            ElevatedButton(
              onPressed: () {
                _firebaseService!.getWorkoutData();
              },
              child: const Text("Sport Get Test"),
            ),
            ElevatedButton(
              onPressed: () {
                Weight weight = Weight(DateTime.now(), 50);
                _firebaseService!.saveWeightData(weight);
              },
              child: const Text("Weight Update Test"),
            ),
            ElevatedButton(
              onPressed: () {
                _firebaseService!.getWeightData();
              },
              child: const Text("Weight Get Test"),
            ),
            const Text(
              "Sport And Weight Container",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomContainer() {
    return Container(
      color: Colors.green,
      width: _deviceWidth,
      child: Center(
        child: Column(
          children: [
            const Center(child: Text("Bottom Container")),
            ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/chart'),
                child: const Text("Chart Page Route"))
          ],
        ),
      ),
    );
  }

  Widget topContainer() {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Column(
          children: [
            const Text(
              "Top Container",
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                Glucose gluc = Glucose(DateTime(2022, 11, 15), 72, 120,
                    Meal.AfterLunch, "Test Note");
                _firebaseService!.saveGlucoseData(gluc);
              },
              child: const Text("Glucose Update Test"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _firebaseService!.getGlucoseData();
              },
              child: const Text("Glucose Get Test"),
            ),
          ],
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

  Future<List> getGlucoseValues() async {
    // return a list of glucose values in the format (Glucose value, Date value saved)
    List? userGlucoseRecords = await _firebaseService!.getGlucoseData();
    if (userGlucoseRecords == null) return [];
    userGlucoseRecords = userGlucoseRecords
        .map((record) => glucoseRecordsWithDateTimeFormat(record))
        .toList();
    userGlucoseRecords = userGlucoseRecords
        .map((record) => ([record['Glucose'], record['Date']]))
        .toList();
    //dev.log("\x1B[37m${userGlucoseRecords.toString()}");
    return userGlucoseRecords;
  }

  double dateFormatToMiliseconds(String formattedDate) {
    List date = formattedDate
        .split("/")
        .map((datePart) => int.parse(datePart))
        .toList();
    DateTime dateTime = DateTime(date[2], date[1], date[0]);
    return dateTime.millisecondsSinceEpoch.toDouble();
  }

  Map glucoseRecordsWithDateTimeFormat(Map record) {
    // gets a map of glucose record and converts the Date timestamp into
    // a DateTime format string according to (dd/MM/yyyy)
    // and returns the updated glucose record as a map
    DateTime timestampToDateTime = (record['Date'] as Timestamp).toDate();
    record['Date'] = DateFormat('dd/MM/yyyy').format(timestampToDateTime);
    return record;
  }
}
