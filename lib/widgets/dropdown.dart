import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

Widget DropDown(
    {required List optionList,
    required double height,
    required double width,
    required String hint,
    TextStyle? textStyle,
    required Function save}) {
  List<DropdownMenuItem<String>> items = optionList
      .map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "DM_Sans",
              ),
            ),
          ))
      .toList();
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: height * 0.02,
    ),
    height: height,
    child: DropdownButtonFormField2(
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.only(bottom: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      isExpanded: true,
      hint: Text(
        hint,
        style: textStyle ??
            TextStyle(
              fontSize: 14,
              fontFamily: "DM_Sans",
            ),
      ),
      items: items,
      onChanged: (value) => save(value),
    ),
  );
}
