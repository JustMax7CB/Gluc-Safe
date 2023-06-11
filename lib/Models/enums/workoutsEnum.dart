import 'package:flutter/material.dart';

enum Workouts {
  Running,
  Swimming,
  Walking,
  Weighttraining,
  Yoga,
  Pilates,
  Cycling
}

List mealsToString(Locale locale) {
  if (locale == Locale('en')) {
    return Workouts.values.map((e) => e.toString().split(".")[1]).toList();
  } else {
    List workouts = [];
    Workouts.values.forEach((element) {
      if (element == Workouts.Cycling)
        workouts.add("רכיבת אופניים");
      else if (element == Workouts.Pilates)
        workouts.add("פילאטיס");
      else if (element == Workouts.Running)
        workouts.add("ריצה");
      else if (element == Workouts.Swimming)
        workouts.add("שחייה");
      else if (element == Workouts.Walking)
        workouts.add("הליכה");
      else if (element == Workouts.Weighttraining)
        workouts.add("הרמת משקולות");
      else if (element == Workouts.Yoga) workouts.add("יוגה");
    });
    return workouts;
  }
}
