// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum Gender {
  Male,
  Female,
  Transgender,
  Nonbinary,
  None,
}

List gendersToString(Locale locale) {
  if (locale == const Locale('en')) {
    return Gender.values.map((e) => e.toString().split(".")[1]).toList();
  } else {
    List genders = [];
    for (var element in Gender.values) {
      if (element == Gender.Male) {
        genders.add("זכר");
      } else if (element == Gender.Female) {
        genders.add("נקבה");
      } else if (element == Gender.Transgender) {
        genders.add("טרנסג'נדר");
      } else if (element == Gender.Nonbinary) {
        genders.add("לא בינארי");
      } else if (element == Gender.None) {
        genders.add("ריק");
      }
    }
    return genders;
  }
}
