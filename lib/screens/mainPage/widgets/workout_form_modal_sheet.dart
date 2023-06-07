import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/Models/enums/workoutsEnum.dart';
import 'package:gluc_safe/Models/workout.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/widgets/dropdown.dart';
import 'package:gluc_safe/widgets/textStroke.dart';
import 'form_input_field.dart';
import 'dart:developer' as dev;

class WorkoutFormModalSheet extends StatefulWidget {
  const WorkoutFormModalSheet(
      {super.key, required this.deviceHeight, required this.deviceWidth});
  final double deviceHeight, deviceWidth;

  @override
  State<WorkoutFormModalSheet> createState() => _WorkoutFormModalSheetState();
}

class _WorkoutFormModalSheetState extends State<WorkoutFormModalSheet> {
  final TextEditingController workoutController = TextEditingController();
  final TextEditingController dateContoller = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
  final TextEditingController durationController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  FirebaseService? _firebaseService;
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _firebaseService = GetIt.instance.get<FirebaseService>();
    super.initState();
  }

  @override
  void dispose() {
    workoutController.clear();
    durationController.clear();
    distanceController.clear();
    dateContoller.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Color.fromRGBO(50, 108, 65, 1),
              width: 5,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(34),
            topRight: Radius.circular(34),
          ),
          color: Color.fromRGBO(211, 229, 214, 1)),
      width: widget.deviceWidth,
      height: widget.deviceHeight * 0.45,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            "main_page_workout_form_title".tr(),
            style: TextStyle(
              fontFamily: "DM_Sans",
              color: Color.fromRGBO(89, 180, 98, 1),
              fontSize: 35,
              fontWeight: FontWeight.w600,
              shadows: <Shadow>[
                Shadow(
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                ),
              ]..addAll(
                  textStroke(
                    0.7,
                    Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FormInputField(
                      deviceHeight: widget.deviceHeight,
                      controller: durationController,
                      deviceWidth: widget.deviceWidth + 50,
                      hintText: "main_page_workout_form_duration".tr(),
                      keyboardType: TextInputType.number,
                    ),
                    FormInputField(
                      deviceHeight: widget.deviceHeight,
                      controller: distanceController,
                      deviceWidth: widget.deviceHeight + 50,
                      hintText: "main_page_workout_form_distance".tr(),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      width: widget.deviceWidth * 0.4,
                      child: DropDown(
                          optionList: Workouts.values
                              .map((e) => e.toString().split(".")[1])
                              .toList(),
                          height: 40,
                          width: 30,
                          hint: "main_page_workout_form_workout".tr(),
                          textStyle: TextStyle(
                            fontSize: 17,
                            fontFamily: "DM_Sans",
                          ),
                          save: (value) => workoutController.text = value),
                    ),
                    FormInputField(
                      deviceHeight: widget.deviceHeight,
                      controller: dateContoller,
                      deviceWidth: widget.deviceWidth,
                      hintText: "main_page_weight_form_date".tr(),
                      keyboardType: TextInputType.datetime,
                      readOnly: true,
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          dateFormat: 'dd/MMMM/yyyy',
                          initialDateTime: DateTime.now(),
                          minDateTime: DateTime(2000),
                          maxDateTime: DateTime.now(),
                          onConfirm: (dateTime, selectedIndex) {
                            String formattedDateTime =
                                DateFormat('dd/MM/yyyy').format(dateTime);
                            dev.log("Formatted Date Time: $formattedDateTime");
                            setState(() {
                              dateContoller.text = formattedDateTime;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: context.locale == Locale('en')
                          ? EdgeInsets.only(left: widget.deviceWidth * 0.11)
                          : EdgeInsets.only(right: widget.deviceWidth * 0.11),
                      child: Text(
                        "main_page_workout_form_optional".tr(),
                        style: TextStyle(
                          fontFamily: "DM_Sans",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      side: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      backgroundColor: Color.fromRGBO(58, 170, 96, 1),
                    ),
                    onPressed: () async {
                      DateFormat format = DateFormat('dd/MM/yyyy');
                      DateTime dateTime = format.parse(dateContoller.text);
                      Workouts workout =
                          Workouts.values.byName(workoutController.text);
                      Workout workoutData;
                      if (workoutController.text == "Running" ||
                          workoutController.text == "Walking" ||
                          workoutController.text == "Cycling") {
                        workoutData = Workout(
                          dateTime,
                          workout,
                          int.parse(durationController.text),
                          int.parse(distanceController.text),
                        );
                      } else {
                        workoutData = Workout(dateTime, workout,
                            int.parse(durationController.text), null);
                      }
                      await _firebaseService!.saveWorkoutData(workoutData);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "main_page_glucose_form_save_btn".tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "DM_Sans",
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        shadows: <Shadow>[
                          Shadow(
                            blurRadius: 2,
                            offset: Offset(1, 2),
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    side: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    backgroundColor: Color.fromRGBO(58, 170, 96, 1),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "misc_cancel".tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "DM_Sans",
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      shadows: <Shadow>[
                        Shadow(
                          blurRadius: 2,
                          offset: Offset(1, 2),
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
