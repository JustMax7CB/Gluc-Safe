import 'package:flutter/material.dart';
import 'package:gluc_safe/Models/enums/days.dart';

class MedReminder {
  late DayEnum _day;
  late TimeOfDay _time;

  MedReminder(DayEnum day, TimeOfDay time) {
    _day = day;
    _time = time;
  }

  get day => _day;
  get time => _time;
}

class MedReminders {
  late List<MedReminder> _reminders;

  MedReminders(List<MedReminder> reminders) {
    _reminders = reminders;
  }

  get reminders => _reminders;
}
