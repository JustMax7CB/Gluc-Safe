// ignore_for_file: file_names, constant_identifier_names

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

List workoutsToList(Locale locale) {
  if (locale == const Locale('en')) {
    return Workouts.values.map((e) => e.toString().split(".")[1]).toList();
  } else {
    List workouts = [];
    for (var element in Workouts.values) {
      if (element == Workouts.Cycling) {
        workouts.add("רכיבת אופניים");
      } else if (element == Workouts.Pilates) {
        workouts.add("פילאטיס");
      } else if (element == Workouts.Running) {
        workouts.add("ריצה");
      } else if (element == Workouts.Swimming) {
        workouts.add("שחייה");
      } else if (element == Workouts.Walking) {
        workouts.add("הליכה");
      } else if (element == Workouts.Weighttraining) {
        workouts.add("הרמת משקולות");
      } else if (element == Workouts.Yoga) {
        workouts.add("יוגה");
      }
    }
    return workouts;
  }
}

String? workoutToString(String workout, Locale locale) {
  if (locale == const Locale('en')) {
    switch (workout) {
      case 'ריצה':
      case 'Running':
        return 'Running';
      case 'שחייה':
      case 'Swimming':
        return 'Swimming';
      case 'הליכה':
      case 'Walking':
        return 'Walking';
      case 'הרמת משקולות':
      case 'Weighttraining':
        return 'Weighttraining';
      case 'יוגה':
      case 'Yoga':
        return 'Yoga';
      case 'פילאטיס':
      case 'Pilates':
        return 'Pilates';
      case 'רכיבת אופניים':
      case 'Cycling':
        return 'Cycling';
    }
  } else {
    switch (workout) {
      case 'ריצה':
      case 'Running':
        return 'ריצה';
      case 'שחייה':
      case 'Swimming':
        return 'שחייה';
      case 'הליכה':
      case 'Walking':
        return 'הליכה';
      case 'הרמת משקולות':
      case 'Weighttraining':
        return 'הרמת משקולות';
      case 'יוגה':
      case 'Yoga':
        return 'יוגה';
      case 'פילאטיס':
      case 'Pilates':
        return 'פילאטיס';
      case 'רכיבת אופניים':
      case 'Cycling':
        return 'רכיבת אופניים';
    }
  }
  return null;
}
