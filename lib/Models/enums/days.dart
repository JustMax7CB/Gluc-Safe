// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum DayEnum {
  Sunday,
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
}

List<String> daysEnumToString(Locale locale) {
  if (locale == const Locale('en')) {
    return List.generate(DayEnum.values.length,
        (index) => DayEnum.values[index].toString().split(".").last);
  } else if (locale == const Locale('he')) {
    return [
      'יום ראשון',
      'יום שני',
      'יום שלישי',
      'יום רביעי',
      'יום חמישי',
      'יום שישי',
      'יום שבת'
    ];
  }
  return ["Not supported locale"];
}

String? dayToString(String day, Locale locale) {
  if (locale == const Locale('en')) {
    switch (day) {
      case 'Sunday':
      case 'יום ראשון':
        return 'Sunday';
      case 'Monday':
      case 'יום שני':
        return 'Monday';
      case 'Tuesday':
      case 'יום שלישי':
        return 'Tuesday';
      case 'Wednesday':
      case 'יום רביעי':
        return 'Wednesday';
      case 'Thursday':
      case 'יום חמישי':
        return 'Thursday';
      case 'Friday':
      case 'יום שישי':
        return 'Friday';
      case 'Saturday':
      case 'יום שבת':
        return 'Saturday';
    }
  } else {
    switch (day) {
      case 'Sunday':
      case 'יום ראשון':
        return 'יום ראשון';
      case 'Monday':
      case 'יום שני':
        return 'יום שני';
      case 'Tuesday':
      case 'יום שלישי':
        return 'יום שלישי';
      case 'Wednesday':
      case 'יום רביעי':
        return 'יום רביעי';
      case 'Thursday':
      case 'יום חמישי':
        return 'יום חמישי';
      case 'Friday':
      case 'יום שישי':
        return 'יום שישי';
      case 'Saturday':
      case 'יום שבת':
        return 'יום שבת';
    }
  }
  return null;
}
