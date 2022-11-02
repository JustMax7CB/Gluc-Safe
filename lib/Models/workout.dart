import 'package:gluc_safe/Models/enums/workoutsEnum.dart';

class Workout {
  late DateTime _dateTime;
  late Workouts _workoutType;
  late int _duration;
  late int? _distance;

  Workout(
      DateTime dateTime, Workouts workoutType, int duration, int? distance) {
    _dateTime = dateTime;
    _workoutType = workoutType;
    _duration = duration;
    _distance = distance;
  }
}
