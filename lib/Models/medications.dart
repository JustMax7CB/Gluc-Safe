import 'package:gluc_safe/Models/med_reminder.dart';

class Medication {
  late String _medicationName;
  late int _numOfPills;
  late int _perDay;
  late MedReminders _reminders;

  Medication(
      String medName, int numOfPills, int perDay, MedReminders reminders) {
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
