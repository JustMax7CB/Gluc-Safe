import 'package:gluc_safe/Models/enums/mealsEnum.dart';

class Glucose {
  late DateTime _date;
  late int _glucoseValue;
  late int? _carbs;
  late Meal? _meal;
  late String? _notes;

  Glucose(
      DateTime date, int glucoseValue, int? carbs, Meal? meal, String? note) {
    _date = date;
    _glucoseValue = glucoseValue;
    _carbs = carbs;
    _meal = meal;
    _notes = note;
  }
}
