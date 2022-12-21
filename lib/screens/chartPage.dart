import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gluc_safe/Models/glucose.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/widgets/chart.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;
import 'package:get_it/get_it.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../Models/enums/enumsExport.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  late double _deviceWidth, _deviceHeight;
  FirebaseService? _firebaseService;
  int? startDate, endDate;

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
                child: SfDateRangePicker(
                  view: DateRangePickerView.month,
                  monthViewSettings:
                      const DateRangePickerMonthViewSettings(firstDayOfWeek: 7),
                  selectionMode: DateRangePickerSelectionMode.range,
                  onSelectionChanged: (_) {
                    selectedDates(_);
                    setState(() {});
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void selectedDates(DateRangePickerSelectionChangedArgs args) {
    DateTime? startDateTime = args.value.startDate;
    DateTime? endDateTime = args.value.endDate;
    dev.log("$startDateTime, $endDateTime");
    if (startDateTime != null && endDateTime != null) {
      startDate = startDateTime.millisecondsSinceEpoch;
      endDate = endDateTime.millisecondsSinceEpoch;
    }
  }

  Future<List> getGlucoseValues() async {
    // return a list of glucose values in the format (Glucose value, Date value saved)

    List? userGlucoseRecords = await _firebaseService!.getGlucoseData();
    if (userGlucoseRecords == null) return [];
    dev.log("Initial List  \x1B[37m$userGlucoseRecords");
    userGlucoseRecords = userGlucoseRecords
        .map((record) => glucoseRecordsToDateTimeFormat(record))
        .toList();
    dev.log("Formatted DateTime List  \x1B[37m$userGlucoseRecords");
    userGlucoseRecords = userGlucoseRecords
        .map((record) => ([record['Glucose'], record['Date']]))
        .toList();
    dev.log("Tuple List  \x1B[37m$userGlucoseRecords");
    userGlucoseRecords = sortDateString(userGlucoseRecords);
    if (startDate == null && endDate == null) {
      startDate = userGlucoseRecords[0][1];
      endDate = userGlucoseRecords[userGlucoseRecords.length - 1][1];
    }
    userGlucoseRecords = userGlucoseRecords
        .where((element) => element[1] >= startDate && element[1] <= endDate)
        .toList();

    userGlucoseRecords = userGlucoseRecords
        .map((e) => [
              e[0],
              DateFormat("dd/MM/yyyy\nHH:mm")
                  .format(DateTime.fromMillisecondsSinceEpoch(e[1]))
            ])
        .toList();
    dev.log("Final List  \x1B[37m$userGlucoseRecords");
    return userGlucoseRecords;
  }

  List sortDateString(List userGlucoseRecords) {
    //dev.log(userGlucoseRecords.toString());
    userGlucoseRecords.sort((a, b) => a[1].compareTo(b[1]));
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

  Map glucoseRecordsToDateTimeFormat(Map record) {
    // gets a map of glucose record and converts the Date timestamp into
    // a DateTime format string according to (dd/MM/yyyy)
    // and returns the updated glucose record as a map
    DateTime timestampToDateTime = (record['Date'] as Timestamp).toDate();
    record['Date'] = timestampToDateTime.millisecondsSinceEpoch;
    return record;
  }
}
