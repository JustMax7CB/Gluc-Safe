import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/Models/MedReminder.dart';
import 'package:gluc_safe/Models/enums/mealsEnum.dart';
import 'package:gluc_safe/Models/glucose.dart';
import 'package:gluc_safe/Models/medications.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/widgets/dropdown.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;

import '../Models/enums/days.dart';

class GlucosePage extends StatefulWidget {
  GlucosePage({super.key});

  @override
  State<GlucosePage> createState() => _GlucosePageState();
}

class _GlucosePageState extends State<GlucosePage> {
  late double _deviceWidth, _deviceHeight;

  FirebaseService? _firebaseService = GetIt.instance.get<FirebaseService>();

  GlucUser? _glucUser;

  final _formkey = GlobalKey<FormState>();

  TextEditingController dateinput = TextEditingController();

  TextEditingController noteText = TextEditingController();

  late int glucoseValue;

  int? carbsValue;

  String? mealValue;

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: buttonsContainer(),
    );
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

  buttonsContainer() {
    return Container(
      color: Colors.amber[600],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                    child: Column(
                      children: [
                        Container(
                          height: _deviceHeight * 0.6,
                          child: Form(
                            key: _formkey,
                            child: glucoseForm(),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Dismiss"),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: const Text("Add Glucose Value"),
          ),
          ElevatedButton(
            onPressed: () async {
              await _firebaseService!.getGlucoseData();
            },
            child: const Text("Glucose Get Test"),
          ),
          ElevatedButton(
              onPressed: () {
                MedReminder m1=MedReminder(Day.Thursday,TimeOfDay(hour: 19,minute:05));
                MedReminder m2=MedReminder(Day.Thursday,TimeOfDay(hour: 6,minute:30));
                MedReminders m=MedReminders([m1,m2]);
                Medication med = Medication("Optalgin",1,2,m);
                _firebaseService!.saveMedicationData(med);
              },
              child: const Text("Madication Update Test"),
            ),
            ElevatedButton(
              onPressed: () {
                _firebaseService!.getMedicationData();
              },
              child: const Text("Madication Get Test"),
            ),
        ],
      ),
    );
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
            glucoseValue = int.parse(value);
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
            carbsValue = int.parse(value);
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
    mealValue = meal;
    dev.log(mealValue.toString());
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
