import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/screens/chartPage/widgets/calendarContainer.dart';
import 'package:gluc_safe/screens/chartPage/widgets/graphContainer.dart';
import 'package:gluc_safe/screens/chartPage/widgets/graph_appbar.dart';
import 'package:gluc_safe/screens/mainPage/widgets/bottom_navbar.dart';
import 'package:gluc_safe/screens/mainPage/widgets/drawer.dart';
import 'package:gluc_safe/screens/pdf_preview.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/widgets/emergencyDialog.dart';
import 'dart:developer' as dev;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  late double _deviceWidth, _deviceHeight;
  int? startDate, endDate, selectedYear, selectedMonth;
  FirebaseService? _firebaseService;
  List options = [
    "chart_option_month".tr(),
    "chart_option_year".tr(),
    "chart_option_range".tr()
  ];
  String? optionSelected;
  DateRangePickerView view = DateRangePickerView.month;
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    super.initState();
    _controller.view = DateRangePickerView.month;
    _firebaseService = GetIt.instance.get<FirebaseService>();
    userContactData();
  }

  void changeOptionSelected(String option) {
    optionSelected = option;
    changeDatePickerView();
  }

  void changeDatePickerView() {
    setState(() {
      switch (optionSelected) {
        case 'Month':
        case 'חודש':
          _controller.view = DateRangePickerView.year;
          break;
        case 'Year':
        case 'שנה':
          _controller.view = DateRangePickerView.decade;
          break;
        default:
          _controller.view = DateRangePickerView.month;
      }
    });
  }

  void setDates(DateRangePickerSelectionChangedArgs args) {
    if (optionSelected == "chart_option_range".tr()) {
      DateTime? startDateTime = args.value.startDate;
      DateTime? endDateTime = args.value.endDate;
      if (startDateTime != null && endDateTime != null) {
        setState(() {
          startDate = startDateTime.millisecondsSinceEpoch;
          endDate = endDateTime.millisecondsSinceEpoch;
        });
        dev.log(
            "startDate: $startDateTime, startMiliseconds: $startDate \nendDate: $endDateTime, endMiliseconds: $endDate");
      }
    } else {
      setState(() {
        selectedMonth = args.value.month;
        selectedYear = args.value.year;
      });
      dev.log("Selected Year: $selectedYear, Selected Month: $selectedMonth");
    }
  }

  Future<Map> glucosePdfData() async {
    Map userData = {};
    userData['user'] = await _firebaseService!.getUserData() as Map;
    List? glucoseData = await _firebaseService!.getGlucoseData();
    if (glucoseData != null) {
      glucoseData = glucoseData
          .map((e) => [
                DateTime.fromMillisecondsSinceEpoch(e['Date']),
                e['Glucose'].toString()
              ])
          .toList();
      userData['glucose'] = glucoseData;
      return userData;
    }
    return {};
  }

  Future<Map> userContactData() async {
    Map contactData = {};
    contactData = await _firebaseService!.getUserData() as Map;
    return {
      'name': contactData['contactName'],
      'phone': contactData['contactNumber']
    };
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      endDrawer: MainDrawer(
        height: _deviceHeight,
        ChangeLanguage: () {
          if (context.locale == Locale('en'))
            context.setLocale(Locale('he'));
          else
            context.setLocale(Locale('en'));
        },
        exportPDF: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FutureBuilder(
                future: glucosePdfData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map userData = snapshot.data as Map;

                    return PdfPreviewPage(
                        locale: context.locale,
                        name:
                            '${userData['user']['firstName']} ${userData['user']['lastName']}',
                        glucoseValues: userData['glucose'] as List);
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          );
        },
      ),
      appBar: AppBar(
        actions: [Container()],
        toolbarHeight: _deviceHeight * 0.11,
        flexibleSpace: GraphAppBar(changeLanguage: () {
          if (context.locale == Locale('en'))
            context.setLocale(Locale('he'));
          else
            context.setLocale(Locale('en'));
        }),
      ),
      bottomNavigationBar: FutureBuilder(
        future: userContactData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BottomNavBar(
              emergency: () => showEmergencyDialog(
                context,
                snapshot.data as Map,
                _deviceWidth,
              ),
            );
          } else {
            return BottomNavBar();
          }
        },
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 7,
            child: GraphContainer(
              optionChoice: changeOptionSelected,
              selectedYear: selectedYear,
              selectedMonth: selectedMonth,
              startDate: startDate,
              endDate: endDate,
            ),
          ),
          Expanded(
            flex: 6,
            child: CalendarContainer(
              controller: _controller,
              allowNavigation: optionSelected == "chart_option_range".tr(),
              selectionMode: optionSelected == "chart_option_range".tr()
                  ? DateRangePickerSelectionMode.range
                  : DateRangePickerSelectionMode.single,
              onSelectionChanged: (args) => setDates(args),
            ),
          )
        ],
      ),
    );
  }
}
