import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:gluc_safe/Models/enums/enumsExport.dart';
import 'package:gluc_safe/Models/glucose.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:gluc_safe/Models/weight.dart';
import 'package:gluc_safe/Models/workout.dart';
import 'dart:developer' as dev;
import 'package:gluc_safe/widgets/dropdown.dart';
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
  final _formkey = GlobalKey<FormState>();
  TextEditingController dateinput = TextEditingController();
  TextEditingController noteText = TextEditingController();
  late int glucoseValue;
  int? carbsValue;
  String? mealValue;

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
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
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
            ),
          ],
        ));
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
              child: const Text("Chart Page Route"),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Glucose Entry"),
                    content: SingleChildScrollView(
                      child: Container(
                        height: _deviceHeight * 0.6,
                        child: Form(
                          key: _formkey,
                          child: glucoseForm(),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: const Text("Add Glucose Value"),
            ),
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

  glucoseForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(left: 10.0),
              filled: false,
              icon: FaIcon(FontAwesomeIcons.bolt, size: 20),
              hintStyle: TextStyle(fontSize: 10),
              labelText: "Glucose Value"),
          onChanged: (value) {
            setState(() {
              glucoseValue = int.parse(value);
            });
          },
        ),
        SizedBox(
          height: _deviceHeight * 0.01,
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(left: 10.0),
              filled: false,
              icon: FaIcon(FontAwesomeIcons.candyCane, size: 18),
              hintStyle: TextStyle(fontSize: 10),
              labelText: "Carbs Value(optional)"),
          onChanged: (value) {
            setState(() {
              carbsValue = int.parse(value);
            });
          },
        ),
        mealDropDown(),
        dateFormField(),
        notesBox(),
        ElevatedButton(
          onPressed: () async {
            List dateStringList = dateinput.text.toString().split("/");
            DateTime date = DateTime(int.parse(dateStringList[2]),
                int.parse(dateStringList[1]), int.parse(dateStringList[0]));
            Glucose gluc = Glucose(date, glucoseValue, carbsValue,
                Meal.AfterDinner, noteText.text);
            await _firebaseService!.saveGlucoseData(gluc);
            dateinput.clear();
            noteText.clear();
            Navigator.pop(context);
          },
          child: const Text("Submit Entry"),
        ),
      ],
    );
  }

  mealDropDown() {
    List meals = Meal.values.map((e) => e.toString().split(".")[1]).toList();
    return DropDown(
        enumsList: meals,
        height: _deviceHeight,
        width: _deviceWidth,
        hint: "Select a Meal(optional)",
        save: saveMealValue);
  }

  saveMealValue(String meal) {
    setState(() {
      mealValue = meal;
      dev.log(mealValue.toString());
    });
  }

  notesBox() {
    return SizedBox(
      height: _deviceHeight * 0.1,
      width: _deviceWidth * 0.8,
      child: TextField(
        controller: noteText,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: "Notes",
          hintText: "Here you can enter your notes",
        ),
      ),
    );
  }

  dateFormField() {
    return TextFormField(
      readOnly: true,
      controller: dateinput,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 10.0),
        filled: false,
        icon: FaIcon(FontAwesomeIcons.calendarDay),
        hintStyle: TextStyle(fontSize: 13),
        labelText: "Entry Date",
      ),
      onTap: calendarShow,
    );
  }

  void calendarShow() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(
            1950), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2050));

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      dev.log(
          formattedDate); //formatted date output using intl package =>  16/03/2021
      //you can implement different kind of Date Format here according to your requirement

      setState(() {
        dateinput.text = formattedDate; //set output date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }
}
