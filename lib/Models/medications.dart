import 'package:flutter/material.dart';

class Medication {
  late String _medicationName;
  late int _numOfPills;
  late int _perDay;
  late List<TimeOfDay> _reminders;

  Medication(
      String medName, int numOfPills, int perDay, List<TimeOfDay> reminders) {
    _medicationName = medName;
    _numOfPills = numOfPills;
    _perDay = perDay;
    _reminders = reminders;
  }

  get medicationName => _medicationName;
  get numOfPills => _numOfPills;
  get perDay => _perDay;
  get reminders => _reminders;
}
