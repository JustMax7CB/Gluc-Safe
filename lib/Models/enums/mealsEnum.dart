// ignore_for_file: file_names, constant_identifier_names

import 'package:flutter/material.dart';

enum Meal {
  BeforeBreakfast,
  AfterBreakfast,
  BeforeLunch,
  AfterLunch,
  BeforeDinner,
  AfterDinner,
}

List workoutsToString(Locale locale) {
  if (locale == const Locale('en')) {
    return Meal.values.map((e) => e.toString().split(".")[1]).toList();
  } else {
    List meals = [];
    for (var element in Meal.values) {
      if (element == Meal.BeforeBreakfast) {
        meals.add("לפני ארוחת בוקר");
      } else if (element == Meal.AfterBreakfast) {
        meals.add("אחרי ארוחת בוקר");
      } else if (element == Meal.BeforeLunch) {
        meals.add("לפני ארוחת צהריים");
      } else if (element == Meal.AfterLunch) {
        meals.add("אחרי ארוחת צהריים");
      } else if (element == Meal.BeforeDinner) {
        meals.add("לפני ארוחת ערב");
      } else if (element == Meal.AfterDinner) {
        meals.add("אחרי ארוחת ערב");
      }
    }
    return meals;
  }
}
