import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
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
            child: Text("glucose_page_chart_page_route".tr()),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("glucose_page_glucose_entry".tr()),
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
                          child: Text("misc_snackbar_dismiss".tr()),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Text("glucose_page_add_glucose_entry".tr()),
          ),
          ElevatedButton(
            onPressed: () async {
              await _firebaseService!.getGlucoseData();
            },
            child: const Text("Glucose Get Test"),
          ),
          ElevatedButton(
            onPressed: () {
              MedReminder m1 =
                  MedReminder(Day.Thursday, TimeOfDay(hour: 19, minute: 05));
              MedReminder m2 =
                  MedReminder(Day.Thursday, TimeOfDay(hour: 6, minute: 30));
              MedReminders m = MedReminders([m1, m2]);
              Medication med = Medication("Optalgin", 1, 2, m);
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
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(left: 10.0),
              filled: false,
              icon: FaIcon(FontAwesomeIcons.bolt, size: 20),
              hintStyle: TextStyle(fontSize: 10),
              labelText: "glucose_page_glucose_value".tr()),
          onChanged: (value) {
            glucoseValue = int.parse(value);
          },
        ),
        SizedBox(
          height: _deviceHeight * 0.01,
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(left: 10.0),
              filled: false,
              icon: FaIcon(FontAwesomeIcons.candyCane, size: 18),
              hintStyle: TextStyle(fontSize: 10),
              labelText: "glucose_page_carbs_value".tr()),
          onChanged: (value) {
            carbsValue = int.parse(value);
          },
        ),
        mealDropDown(),
        GestureDetector(
          child: TextFormField(
            readOnly: true,
            controller: dateinput,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(left: 10.0),
              filled: false,
              icon: FaIcon(FontAwesomeIcons.calendarDay),
              hintStyle: TextStyle(fontSize: 13),
              labelText: "glucose_page_entry_date".tr(),
            ),
            onTap: dateFormField,
          ),
        ),
        notesBox(),
        ElevatedButton(
          onPressed: () async {
            List dateTimeStringList =
                dateinput.text.split(" "); // ["dd/MM/yyyy", "HH:mm"]
            List dateStringList = dateTimeStringList[0]
                .split("/")
                .map((num) => int.parse(num))
                .toList(); // [dd,MM,yyyy]
            List timeStringList = dateTimeStringList[1]
                .split(":")
                .map((num) => int.parse(num))
                .toList(); // [HH, mm]

            DateTime date = DateTime(dateStringList[2], dateStringList[1],
                dateStringList[0], timeStringList[0], timeStringList[1]);

            Glucose gluc = Glucose(date, glucoseValue, carbsValue,
                Meal.AfterDinner, noteText.text);
            await _firebaseService!.saveGlucoseData(gluc);
            dateinput.clear();
            noteText.clear();
            Navigator.pop(context);
          },
          child: Text("glucose_page_submit_entry".tr()),
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
        hint: "glucose_page_meal_select".tr(),
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
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: "glucose_page_entry_note_label".tr(),
          hintText: "glucose_page_entry_note_hint".tr(),
        ),
      ),
    );
  }

  DateTime IL_TimezoneConvert(DateTime dateTime) {
    int hours = dateTime.hour + 2;
    return DateTime(
        dateTime.year, dateTime.month, dateTime.day, hours, dateTime.minute);
  }

  dateFormField() {
    DatePicker.showDatePicker(
      context,
      dateFormat: 'dd/MMMM/yyyy HH:mm',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime(2000),
      maxDateTime: IL_TimezoneConvert(DateTime.now()),
      onConfirm: (dateTime, selectedIndex) {
        String formattedDateTime =
            DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
        dev.log("Formatted Date Time: $formattedDateTime");
        setState(() {
          dateinput.text = formattedDateTime;
        });
      },
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
      String formattedDate = DateFormat('dd/MM/yyyy\nH:m').format(pickedDate);
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
