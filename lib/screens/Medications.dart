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
  GlucUser? _glucUser;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body:FutureBuilder(
        future: getMedicationsValues(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List medications = snapshot.data as List;
            return Text(
              "${medications}",
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
    );
  }


  Future<List> getMedicationsValues() async {
    // return a list of glucose values in the format (Glucose value, Date value saved)
    List? userMedicationsRecords = await _firebaseService!.getMedicationData();
    if (userMedicationsRecords == null) return [];
    dev.log("Initial List  \x1B[37m$userMedicationsRecords");
    userMedicationsRecords = userMedicationsRecords
        .map((record) => medicationsRecordsToDateTimeFormat(record))
        .toList();
    dev.log("Formatted DateTime List  \x1B[37m$userMedicationsRecords");
    return userMedicationsRecords;
  }


  Map medicationsRecordsToDateTimeFormat(Map record) {
    // gets a map of glucose record and converts the Date timestamp into
    // a DateTime format string according to (dd/MM/yyyy)
    // and returns the updated glucose record as a map
    List rem=record['reminders'];
    for (var i = 0; i < rem.length; i++) {
      DateTime timestampToDateTime = (rem[i] as Timestamp).toDate();
      rem[i]=timestampToDateTime;
    }
    record['reminders']=rem;
    return record;
  }
}
