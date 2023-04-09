import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/Models/enums/mealsEnum.dart';
import 'package:gluc_safe/Models/glucose.dart';
import 'package:gluc_safe/screens/mainPage/widgets/form_input_field.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/widgets/dropdown.dart';
import 'package:gluc_safe/widgets/textStroke.dart';
import 'dart:developer' as dev;

class GlucoseFormModalSheet extends StatefulWidget {
  GlucoseFormModalSheet({super.key});

  @override
  State<GlucoseFormModalSheet> createState() => _GlucoseFormModalSheetState();
}

class _GlucoseFormModalSheetState extends State<GlucoseFormModalSheet> {
  FirebaseService? _firebaseService;
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController dateContoller = TextEditingController(
      text: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()));
  final TextEditingController mealController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    _firebaseService = GetIt.instance.get<FirebaseService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _deviceHeight = MediaQuery.of(context).size.height;
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
      width: _deviceWidth,
      height: _deviceHeight * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "main_page_glucose_form_title".tr(),
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
                      controller: glucoseController,
                      deviceWidth: _deviceWidth,
                      hintText: "main_page_glucose_form_glocuse".tr(),
                      keyboardType: TextInputType.number,
                    ),
                    FormInputField(
                      controller: carbsController,
                      deviceWidth: _deviceWidth,
                      hintText: "main_page_glucose_form_carbs".tr(),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FormInputField(
                      controller: dateContoller,
                      deviceWidth: _deviceWidth,
                      hintText: "main_page_glucose_form_date".tr(),
                      keyboardType: TextInputType.number,
                      readOnly: true,
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          dateFormat: 'dd/MMMM/yyyy HH:mm',
                          initialDateTime: DateTime.now(),
                          minDateTime: DateTime(2000),
                          maxDateTime: DateTime.now(),
                          onConfirm: (dateTime, selectedIndex) {
                            String formattedDateTime =
                                DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
                            dev.log("Formatted Date Time: $formattedDateTime");
                            setState(() {
                              dateContoller.text = formattedDateTime;
                            });
                          },
                        );
                      },
                    ),
                    Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        width: _deviceWidth * 0.35,
                        child: DropDown(
                            optionList: Meal.values
                                .map((e) => e.toString().split(".")[1])
                                .toList(),
                            height: 40,
                            width: 30,
                            hint: "main_page_glucose_form_meal".tr(),
                            textStyle: TextStyle(
                              fontSize: 17,
                              fontFamily: "DM_Sans",
                            ),
                            save: (value) => mealController.text = value)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: _deviceWidth * 0.13, vertical: 5),
                      child: TextField(
                        controller: notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "main_page_glucose_form_notes".tr(),
                          hintStyle: TextStyle(
                            fontFamily: "DM_Sans",
                            fontSize: 17,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: context.locale == Locale('en')
                          ? EdgeInsets.only(left: _deviceWidth * 0.13)
                          : EdgeInsets.only(right: _deviceWidth * 0.13),
                      child: Text(
                        "main_page_glucose_form_optional".tr(),
                        style: TextStyle(
                          fontFamily: "DM_Sans",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
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
                  onPressed: () async {
                    DateFormat format = DateFormat('dd/MM/yyyy HH:mm');
                    DateTime dateTime = format.parse(dateContoller.text);
                    Glucose glucoseData = Glucose(
                        dateTime,
                        int.parse(glucoseController.text),
                        carbsController.text.isNotEmpty
                            ? int.parse(carbsController.text)
                            : 0,
                        mealController.text.isNotEmpty
                            ? Meal.values.firstWhere((element) =>
                                element.toString().split(".")[1] ==
                                mealController.text)
                            : null,
                        notesController.text.isNotEmpty
                            ? notesController.text
                            : null);

                    await _firebaseService!.saveGlucoseData(glucoseData);

                    setState(() {
                      dateContoller.text =
                          DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
                      mealController.clear();
                      glucoseController.clear();
                      carbsController.clear();
                      notesController.clear();
                    });
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
                    "main_page_glucose_form_cancel_btn".tr(),
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
