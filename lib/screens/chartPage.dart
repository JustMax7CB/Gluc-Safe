import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gluc_safe/Models/glucose.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/widgets/chart.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;
import 'package:get_it/get_it.dart';

import '../Models/enums/enumsExport.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  late double _deviceWidth, _deviceHeight;
  FirebaseService? _firebaseService;

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
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                  color: Colors.blue,
                  child: FutureBuilder(
                    future: getGlucoseValues(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return LineChartWidget(
                            glucoseValues: snapshot.data as List,
                            deviceHeight: _deviceHeight,
                            deviceWidth: _deviceWidth);
                      }
                      return const CircularProgressIndicator();
                    },
                  )),
            ),
            Expanded(
              flex: 2,
              child: Container(
                  width: _deviceWidth,
                  color: Colors.red,
                  child: ElevatedButton(
                    onPressed: () {
                      Glucose gluc = Glucose(DateTime(2022, 2, 12), 12, 120,
                          Meal.AfterLunch, "Test Note");
                      _firebaseService!.saveGlucoseData(gluc);
                      setState(() {});
                    },
                    child: const Text("Glucose Update Test"),
                  )),
            )
          ],
        ),
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
    userGlucoseRecords = sortDateString(userGlucoseRecords);
    dev.log("\x1B[37m$userGlucoseRecords");
    return userGlucoseRecords;
  }

  List sortDateString(List userGlucoseRecords) {
    dev.log(userGlucoseRecords.toString());
    List records = userGlucoseRecords
        .map((recordTuple) =>
            [recordTuple[0], dateFormatToMiliseconds(recordTuple[1])])
        .toList();
    records.sort((a, b) => a[1].compareTo(b[1]));
    records = records
        .map((record) => [
              record[0],
              DateFormat('dd/MM/yyyy').format(
                  DateTime.fromMillisecondsSinceEpoch(record[1].toInt())),
            ])
        .toList();
    dev.log(records.toString());
    return records;
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
