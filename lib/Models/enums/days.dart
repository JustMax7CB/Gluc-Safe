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

List DaysToString(Locale locale) {
  if (locale == Locale('en')) {
    return DayEnum.values.map((e) => e.toString().split(".")[1]).toList();
  } else {
    List days = [];
    DayEnum.values.forEach((element) {
      if (element == DayEnum.Sunday)
        days.add("יום ראשון");
      else if (element == DayEnum.Monday)
        days.add("יום שני");
      else if (element == DayEnum.Tuesday)
        days.add("יום שלישי");
      else if (element == DayEnum.Wednesday)
        days.add("יום רביעי");
      else if (element == DayEnum.Thursday)
        days.add("יום חמישי");
      else if (element == DayEnum.Friday)
        days.add("יום שישי");
      else if (element == DayEnum.Saturday) days.add("יום שבת");
    });
    return days;
  }
}
