import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/widgets/chart.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:developer' as dev;

import 'filterOptions.dart';

class GraphContainer extends StatefulWidget {
  GraphContainer({
    super.key,
    required this.optionChoice,
    this.selectedYear,
    this.selectedMonth,
    this.startDate,
    this.endDate,
    required this.deviceWidth,
    required this.deviceHeight,
  });
  final Function optionChoice;
  int? startDate, endDate, selectedYear, selectedMonth;
  final double deviceWidth, deviceHeight;

  @override
  State<GraphContainer> createState() => _GraphContainerState();
}

class _GraphContainerState extends State<GraphContainer> {
  FirebaseService? _firebaseService;
  late String optionSelected;
  List options = [
    "chart_option_month".tr(),
    "chart_option_year".tr(),
    "chart_option_range".tr()
  ];

  final DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    optionSelected = options.first;
    _controller.view = DateRangePickerView.month;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(213, 233, 217, 1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.black),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "chart_page_select_option".tr(),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              FilterOptionsContainer(
                deviceWidth: widget.deviceWidth,
                deviceHeight: widget.deviceHeight,
                optionChoice: (option) {
                  widget.optionChoice(option);
                  setState(() {
                    optionSelected = option;
                  });
                },
              ),
            ],
          ),
          FutureBuilder(
            future: getGlucoseValues(optionSelected),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return LineChartWidget(
                    glucoseValues: snapshot.data as List,
                    deviceHeight: widget.deviceHeight,
                    deviceWidth: widget.deviceWidth);
              }
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  List glucoseByRange(List userGlucoseRecords) {
    if (widget.startDate == null &&
        widget.endDate == null &&
        userGlucoseRecords.isNotEmpty) {
      widget.startDate = userGlucoseRecords[0][1];
      widget.endDate = userGlucoseRecords[userGlucoseRecords.length - 1][1];
    }

    userGlucoseRecords = userGlucoseRecords
        .where((element) =>
            element[1] >= widget.startDate && element[1] <= widget.endDate)
        .toList();

    return userGlucoseRecords;
  }

  List glucoseByYear(List userGlucoseRecords) {
    dev.log(userGlucoseRecords.toString());
    dev.log(widget.selectedYear.toString());
    userGlucoseRecords = userGlucoseRecords
        .where((element) =>
            (DateTime.fromMillisecondsSinceEpoch(element[1]).year ==
                widget.selectedYear))
        .toList();
    return userGlucoseRecords;
  }

  List glucoseByMonth(List userGlucoseRecords) {
    userGlucoseRecords = userGlucoseRecords
        .where((element) =>
            (DateTime.fromMillisecondsSinceEpoch(element[1]).month ==
                widget.selectedMonth))
        .toList();
    return userGlucoseRecords;
  }

  Future<List> getGlucoseValues(String mode) async {
    // return a list of glucose values in the format (Glucose value, Date value saved)
    List? userGlucoseRecords =
        await _firebaseService!.getGlucoseData().then((result) {
      if (result == null) return [];
      return result
          .map((record) => ([record['Glucose'], record['Date']]))
          .toList();
    });
    if (userGlucoseRecords == null) return [];
    dev.log("Initial List  \x1B[37m$userGlucoseRecords");
    userGlucoseRecords = sortDateString(userGlucoseRecords);
    dev.log("Sorted Tuple List  \x1B[37m$userGlucoseRecords");

    if (mode == "chart_option_range".tr()) {
      userGlucoseRecords = glucoseByRange(userGlucoseRecords);
    } else if (mode == "chart_option_year".tr()) {
      userGlucoseRecords = glucoseByYear(userGlucoseRecords);
    } else if (mode == "chart_option_month".tr()) {
      userGlucoseRecords = glucoseByMonth(userGlucoseRecords);
    }

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
}
