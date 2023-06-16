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

List mealsToList(Locale locale) {
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

String? mealToString(String meal, Locale locale) {
  if (locale == const Locale('en')) {
    switch (meal) {
      case 'BeforeBreakfast':
      case 'לפני ארוחת בוקר':
        return 'BeforeBreakfast';
      case 'AfterBreakfast':
      case 'אחרי ארוחת בוקר':
        return 'AfterBreakfast';
      case 'BeforeLunch':
      case 'לפני ארוחת צהריים':
        return 'BeforeLunch';
      case 'AfterLunch':
      case 'אחרי ארוחת צהריים':
        return 'AfterLunch';
      case 'BeforeDinner':
      case 'לפני ארוחת ערב':
        return 'BeforeDinner';
      case 'AfterDinner':
      case 'אחרי ארוחת ערב':
        return 'AfterDinner';
    }
  } else if (locale == const Locale('he')) {
    switch (meal) {
      case 'BeforeBreakfast':
      case 'לפני ארוחת בוקר':
        return 'לפני ארוחת בוקר';
      case 'AfterBreakfast':
      case 'אחרי ארוחת בוקר':
        return 'אחרי ארוחת בוקר';
      case 'BeforeLunch':
      case 'לפני ארוחת צהריים':
        return 'לפני ארוחת צהריים';
      case 'AfterLunch':
      case 'אחרי ארוחת צהריים':
        return 'אחרי ארוחת צהריים';
      case 'BeforeDinner':
      case 'לפני ארוחת ערב':
        return 'לפני ארוחת ערב';
      case 'AfterDinner':
      case 'אחרי ארוחת ערב':
        return 'אחרי ארוחת ערב';
    }
  }
  return null;
}
