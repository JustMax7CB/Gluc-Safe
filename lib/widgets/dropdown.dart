import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

Widget DropDown(
    {required List enumsList,
    required double height,
    required double width,
    required String hint,
    required Function save}) {
  //List meals = Meal.values.map((e) => e.toString().split(".")[1]).toList();
  List<DropdownMenuItem<String>> items = enumsList
      .map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ))
      .toList();
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: height * 0.02,
    ),
    width: width * 0.5,
    child: DropdownButtonFormField2(
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      isExpanded: true,
      hint: Text(
        hint,
        style: TextStyle(fontSize: 14),
      ),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: height * 0.05,
      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: items,
      onChanged: (value) {
        save(value);
      },
    ),
  );
}
