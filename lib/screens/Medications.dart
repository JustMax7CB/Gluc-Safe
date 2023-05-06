import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/Models/enums/enumsExport.dart';
import 'package:gluc_safe/Models/glucose.dart';
import 'package:gluc_safe/Models/medications.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:gluc_safe/Models/weight.dart';
import 'package:gluc_safe/Models/workout.dart';
import 'package:gluc_safe/widgets/customAppBar.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:gluc_safe/screens/mainPage/widgets/card_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gluc_safe/screens/mainPage/widgets/card_button.dart';
import 'package:gluc_safe/screens/mainPage/widgets/medication_form_modal_sheet.dart';

import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key});

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  late double _deviceWidth, _deviceHeight;
  FirebaseService? _firebaseService;
  late DateTime _date = DateTime.now();
  List<dynamic>? medList = [];
  GlucUser? _glucUser;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    getMedicine(_date.toString());
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Medicine Reminder"),
        backgroundColor: Color.fromARGB(255, 66, 146, 75),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        width: _deviceWidth,
        height: _deviceHeight * 0.8,
        child: Column(
          children: [
            HorizontalCalendar(
              date: DateTime.now(),
              textColor: Colors.black45,
              backgroundColor: Colors.white,
              selectedColor: Color.fromARGB(255, 66, 146, 75),
              showMonth: true,
              onDateSelected: (date) {
                getMedicine(date);
              },
            ),
            Container(
                height: _deviceHeight * 0.6,
                margin: EdgeInsets.fromLTRB(20, 60, 20, 0),
                child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.32,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 15,
                    children: MedicationsDisplay())),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          isDismissible: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(34),
              topRight: Radius.circular(34),
            ),
          ),
          context: context,
          builder: (context) => Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: MedicationFormModalSheet(),
          ),
        ),
      ),
    );
  }

  void getMedicine(dynamic date) async {
    List? medtemp = await _firebaseService!.getMedicationData();
    DateTime dt = DateTime.parse(date);
    setState(() {
      medList = medtemp;
      _date = dt;
    });
  }

  List<Widget> MedicationsDisplay() {
    List<Widget> ListWidgets = [];
    for (var med in medList!) {
      if (isTheSameDay(med))
        ListWidgets.add(
          CardButton(
              onTap: () => {},
              title: med["medicationName"].toString(),
              icon: Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: SvgPicture.asset(
                      "lib/assets/icons_svg/medicine_icon.svg",
                      height: 30))),
        );
    }
    return ListWidgets;
  }

  bool isTheSameDay(var med) {
    int dayOfWeek = _date.weekday;
    String Day;
    switch (dayOfWeek) {
      case 1:
        Day = "Monday";
        break;
      case 2:
        Day = "Tuesday";
        break;
      case 3:
        Day = "Wednesday";
        break;
      case 4:
        Day = "Thursday";
        break;
      case 5:
        Day = "Friday";
        break;
      case 6:
        Day = "Saturday";
        break;
      case 7:
        Day = "Sunday";
        break;
      default:
        Day = "Monday";
        break;
    }
    for (var rem in med["reminders"]!) {
      if (rem["Day"] == Day) return true;
    }

    return false;
  }
}
