import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:gluc_safe/screens/medicationPage/widgets/drawer.dart';
import 'package:gluc_safe/Models/bolus.dart';
import 'package:gluc_safe/screens/BolusCalculatorPage/widgets/boluscalc_page_appbar.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:gluc_safe/services/deviceQueries.dart';
import 'dart:developer' as dev;

class BolusCalcPage extends StatefulWidget {
  const BolusCalcPage({super.key});

  @override
  State<BolusCalcPage> createState() => _BolusCalcPageState();
}

class _BolusCalcPageState extends State<BolusCalcPage> {
  double? _deviceWidth, _deviceHeight;
  FirebaseService? _firebaseService;
  //Meal Bolus
  double carbohydrateIntake = 0;
  double carbohydrateRatio = 0;
  //Correction Bolus
  double bloodGlucose = 0;
  double targetGlucose = 0;
  double correctionFactor = 0;

  double bolusDose = 0;
  double ResultBolus = 0;

  bool isMealDose = false;
  bool isCorrectionDose = false;
  bool isCalculatePressed = false;

  late Bolus bolusData;

  var carbohydrateIntakeController = TextEditingController();
  var carbohydrateRatioController = TextEditingController();
  //Correction Bolus
  var bloodGlucoseController = TextEditingController();
  var targetGlucoseController = TextEditingController();
  var correctionFactorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    if (_deviceWidth == null || _deviceHeight == null) {
      _deviceWidth = getDeviceWidth(context);
      _deviceHeight = getDeviceHeight(context);
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _deviceHeight! * 0.11,
        flexibleSpace:
            BolusCalcAppBar(changeLanguage: () {}, width: _deviceWidth!),
      ),
      endDrawer: MedicationPageDrawer(
        height: _deviceHeight!,
        ChangeLanguage: () {
          if (context.locale == Locale('en'))
            context.setLocale(Locale('he'));
          else
            context.setLocale(Locale('en'));
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "bolus_caculator_meal_bolus".tr(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: carbohydrateIntakeController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                  labelText: "bolus_caculator_carbohydrate_intake".tr()),
              onChanged: (value) {
                carbohydrateIntake = double.tryParse(value) ?? 0;
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: carbohydrateRatioController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                  labelText: "bolus_caculator_carbohydrate_ratio".tr()),
              onChanged: (value) {
                carbohydrateRatio = double.tryParse(value) ?? 0;
              },
            ),
            SizedBox(height: 16.0),
            Text(
              "bolus_caculator_correction_bolus".tr(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: bloodGlucoseController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                  labelText: "bolus_caculator_blood_glucose".tr()),
              onChanged: (value) {
                bloodGlucose = double.tryParse(value) ?? 0;
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: correctionFactorController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                  labelText: "bolus_caculator_correction_factor".tr()),
              onChanged: (value) {
                correctionFactor = double.tryParse(value) ?? 0;
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: targetGlucoseController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                  labelText: "bolus_caculator_target_glucose".tr()),
              onChanged: (value) {
                targetGlucose = double.tryParse(value) ?? 0;
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isCalculatePressed = true;
                  if (correctionFactor != 0) {
                    bolusDose = bolusDose +
                        ((bloodGlucose - targetGlucose) / correctionFactor);
                    isCorrectionDose = true;
                  }
                  if (carbohydrateRatio != 0) {
                    bolusDose =
                        bolusDose + (carbohydrateIntake / carbohydrateRatio);
                    isMealDose = true;
                  }
                  ResultBolus = bolusDose;
                  bolusData = new Bolus(
                      DateTime.now(),
                      isMealDose,
                      isCorrectionDose,
                      carbohydrateIntake,
                      carbohydrateRatio,
                      bloodGlucose,
                      targetGlucose,
                      correctionFactor,
                      bolusDose);
                  carbohydrateIntake = 0;
                  carbohydrateRatio = 0;
                  bloodGlucose = 0;
                  targetGlucose = 0;
                  correctionFactor = 0;
                  bolusDose = 0;
                  carbohydrateIntakeController.clear();
                  carbohydrateRatioController.clear();
                  bloodGlucoseController.clear();
                  targetGlucoseController.clear();
                  correctionFactorController.clear();
                });
              },
              child: Text("bolus_caculator_calculate_bolus".tr()),
            ),
            SizedBox(height: 16.0),
            Text(
              '${"bolus_caculator_bolus_dose".tr()} ${ResultBolus.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (isCalculatePressed) {
                  await _firebaseService!.saveBolusData(bolusData);
                }
                isCalculatePressed = false;
              },
              child: Text("bolus_caculator_save_entry".tr()),
            ),
          ],
        ),
      ),
    );
  }
}
