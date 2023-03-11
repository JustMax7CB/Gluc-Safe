import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/widgets/chart.dart';
import 'package:gluc_safe/widgets/dropdown.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;
import 'package:get_it/get_it.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  late double _deviceWidth, _deviceHeight;
  FirebaseService? _firebaseService;
  int? startDate, endDate, selectedYear, selectedMonth;
  List options = ['Month', 'Year', 'Range'];
  late String optionSelected;
  DateRangePickerView view = DateRangePickerView.month;
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
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropDown(
            enumsList: options,
            height: 700,
            width: 400,
            hint: 'Select Option',
            save: (selection) {
              setState(() {
                optionSelected = selection;
                optionView();
              });
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                  color: Colors.blue,
                  child: FutureBuilder(
                    future: getGlucoseValues(optionSelected),
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
                  controller: _controller,
                  allowViewNavigation: optionSelected == 'Range',
                  selectionMode: optionSelected == 'Range'
                      ? DateRangePickerSelectionMode.range
                      : DateRangePickerSelectionMode.single,
                  onSelectionChanged: (_) {
                    optionSelected == 'Range'
                        ? selectedRangeDates(_)
                        : selectedSingleDate(_);
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

  void optionView() {
    switch (optionSelected) {
      case 'Month':
        _controller.view = DateRangePickerView.year;
        break;
      case 'Year':
        _controller.view = DateRangePickerView.decade;
        break;
      default:
        _controller.view = DateRangePickerView.month;
    }
  }

  void selectedSingleDate(DateRangePickerSelectionChangedArgs args) {
    String ViewMode = optionSelected;
    selectedYear = args.value.year;
    selectedMonth = args.value.month;
    // dev.log(selectedYear.toString());
    // dev.log(selectedMonth.toString());
  }

  void selectedRangeDates(DateRangePickerSelectionChangedArgs args) {
    DateTime? startDateTime = args.value.startDate;
    DateTime? endDateTime = args.value.endDate;
    // dev.log("$startDateTime, $endDateTime");
    if (startDateTime != null && endDateTime != null) {
      startDate = startDateTime.millisecondsSinceEpoch;
      endDate = endDateTime.millisecondsSinceEpoch;
    }
  }

  List GlucoseByRange(List userGlucoseRecords) {
    if (startDate == null && endDate == null && userGlucoseRecords.length > 0) {
      startDate = userGlucoseRecords[0][1];
      endDate = userGlucoseRecords[userGlucoseRecords.length - 1][1];
    }
    userGlucoseRecords = userGlucoseRecords
        .where((element) => element[1] >= startDate && element[1] <= endDate)
        .toList();

    return userGlucoseRecords;
  }

  List GlucoseByYear(List userGlucoseRecords) {
    userGlucoseRecords = userGlucoseRecords
        .where((element) =>
            (DateTime.fromMillisecondsSinceEpoch(element[1]).year ==
                selectedYear))
        .toList();
    return userGlucoseRecords;
  }

  List GlucoseByMonth(List userGlucoseRecords) {
    userGlucoseRecords = userGlucoseRecords
        .where((element) =>
            (DateTime.fromMillisecondsSinceEpoch(element[1]).month ==
                selectedMonth))
        .toList();
    return userGlucoseRecords;
  }

  Future<List> getGlucoseValues(String mode) async {
    // return a list of glucose values in the format (Glucose value, Date value saved)

    List? userGlucoseRecords = await _firebaseService!.getGlucoseData();
    if (userGlucoseRecords == null) return [];
    dev.log("Initial List  \x1B[37m$userGlucoseRecords");

    userGlucoseRecords = userGlucoseRecords
        .map((record) => ([record['Glucose'], record['Date']]))
        .toList();
    dev.log("Tuple List  \x1B[37m$userGlucoseRecords");
    userGlucoseRecords = sortDateString(userGlucoseRecords);

    if (mode == "Range") {
      userGlucoseRecords = GlucoseByRange(userGlucoseRecords);
    } else if (mode == "Year") {
      userGlucoseRecords = GlucoseByYear(userGlucoseRecords);
    } else if (mode == "Month") {
      userGlucoseRecords = GlucoseByMonth(userGlucoseRecords);
    } else {}

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
}
