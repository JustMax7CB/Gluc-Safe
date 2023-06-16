import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class glucoseValuePicker extends StatefulWidget {
  double? glucoseValue = 100;
  glucoseValuePicker({super.key});

  @override
  State<glucoseValuePicker> createState() => _glucoseValuePickerState();
}

class _glucoseValuePickerState extends State<glucoseValuePicker> {
  double? glucoseValue = 100;

  @override
  Widget build(BuildContext context) {
    return NumberPicker(
      value: widget.glucoseValue!.toInt(),
      minValue: 50,
      maxValue: 150,
      onChanged: (value) =>
          setState(() => widget.glucoseValue = value.toDouble()),
    );
  }
}
