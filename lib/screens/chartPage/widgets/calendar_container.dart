import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// ignore: unused_import
import 'dart:developer' as dev;

class CalendarContainer extends StatefulWidget {
  const CalendarContainer({
    super.key,
    required this.controller,
    required this.allowNavigation,
    required this.selectionMode,
    required this.onSelectionChanged,
  });
  final DateRangePickerController controller;
  final bool allowNavigation;
  final DateRangePickerSelectionMode selectionMode;
  final Function onSelectionChanged;

  @override
  State<CalendarContainer> createState() => _CalendarContainerState();
}

class _CalendarContainerState extends State<CalendarContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(213, 233, 217, 1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.black),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(5),
      child: SfDateRangePicker(
        monthViewSettings: const DateRangePickerMonthViewSettings(
          showWeekNumber: true,
          weekendDays: [5, 6],
          firstDayOfWeek: 7,
        ),
        monthCellStyle: const DateRangePickerMonthCellStyle(
          weekendTextStyle: TextStyle(
            color: Color.fromARGB(255, 20, 48, 207),
          ),
        ),
        showNavigationArrow: true,
        headerStyle: const DateRangePickerHeaderStyle(
          textAlign: TextAlign.center,
          textStyle: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        controller: widget.controller,
        allowViewNavigation: widget.allowNavigation,
        selectionMode: widget.selectionMode,
        onSelectionChanged: (_) {
          widget.onSelectionChanged(_);
        },
      ),
    );
  }
}