import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/Models/enums/workoutsEnum.dart';
import 'package:gluc_safe/Models/workout.dart';
import 'package:gluc_safe/services/database.dart';

class WorkoutPage extends StatelessWidget {
  WorkoutPage({super.key});

  double? _deviceWidth, _deviceHeight;
  FirebaseService? _firebaseService = GetIt.instance.get<FirebaseService>();

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.yellow,
      width: _deviceWidth,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Workout workout = Workout(DateTime.now(), Workouts.Yoga, 60, 0);
                _firebaseService!.saveWorkoutData(workout);
              },
              child: const Text("Sport Update Test"),
            ),
            ElevatedButton(
              onPressed: () {
                _firebaseService!.getWorkoutData();
              },
              child: const Text("Sport Get Test"),
            )
          ],
        ),
      ),
    );
  }
}
