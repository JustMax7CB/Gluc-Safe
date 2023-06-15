import 'package:cloud_firestore/cloud_firestore.dart';
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
                  if (bolusDose - bolusDose.toInt() > 0.5) {
                    bolusDose = bolusDose.toInt() + 1;
                  } else {
                    bolusDose = bolusDose.toInt().toDouble();
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
                  isMealDose = false;
                  isCorrectionDose = false;
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
                bool temp = await isLastBolusTime(Timestamp.now());
                if (temp == false) {
                  _showAlertDialog(context);
                  isCalculatePressed = false;
                }
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

  Future<bool> isLastBolusTime(Timestamp date) async {
    List? bolustemp = await _firebaseService!.getBolusData();
    List tlist;
    int? time;
    Timestamp t;
    bool isCorrection = false;
    int dt = date.millisecondsSinceEpoch;
    if (bolustemp!.isNotEmpty) {
      dev.log(bolustemp.last['Date'].toString());
      dev.log(bolustemp.last['is Correction Bolus'].toString());
      tlist = bolustemp
          .where((item) => item['is Correction Bolus'] == true)
          .toList();
      dev.log(tlist.toString());
      if (tlist!.isNotEmpty) {
        isCorrection = tlist.last['is Correction Bolus'];
        time = (dt - tlist.last['Date']) as int?;
        dev.log(Timestamp.fromMillisecondsSinceEpoch(time!).toString());
        t = Timestamp.fromMillisecondsSinceEpoch(time);
        if (t.seconds / 3600 > 3) {
          dev.log("more then 3 hours");
          return true;
        } else {
          dev.log("less then 3 hours");
          return false;
        }
      }
    }
    return true;
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("bolus_caculator_alert".tr()),
          content: Text("bolus_caculator_alert_text".tr()),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
