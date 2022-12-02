import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/Models/weight.dart';
import 'package:gluc_safe/services/database.dart';

class WeightPage extends StatelessWidget {
  WeightPage({super.key});
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
                Weight weight = Weight(DateTime.now(), 50);
                _firebaseService!.saveWeightData(weight);
              },
              child: const Text("Weight Update Test"),
            ),
            ElevatedButton(
              onPressed: () {
                _firebaseService!.getWeightData();
              },
              child: const Text("Weight Get Test"),
            )
          ],
        ),
      ),
    );
  }
}
