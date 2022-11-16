import 'package:gluc_safe/Models/enums/workoutsEnum.dart';

class Workout {
  late DateTime _dateTime;
  late Workouts _workoutType;
  late int _duration;
  int? _distance;

  Workout(
      DateTime dateTime, Workouts workoutType, int duration, int? distance) {
    _dateTime = dateTime;
    _workoutType = workoutType;
    _duration = duration;
    _distance = distance;
  }

  get date => _dateTime;
  get workoutType => _workoutType;
  get duration => _duration;
  get distance => _distance;
}
