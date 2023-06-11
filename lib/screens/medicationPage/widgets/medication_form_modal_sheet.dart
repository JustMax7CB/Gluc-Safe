import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/Models/MedReminder.dart';
import 'package:gluc_safe/Models/enums/days.dart';
import 'package:gluc_safe/Models/medications.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/widgets/dropdown.dart';
import 'package:gluc_safe/widgets/textStroke.dart';
import '../../mainPage/widgets/form_input_field.dart';
import 'dart:developer' as dev;

class MedicationFormModalSheet extends StatefulWidget {
  const MedicationFormModalSheet(
      {super.key, required this.deviceHeight, required this.deviceWidth});
  final double deviceHeight, deviceWidth;

  @override
  State<MedicationFormModalSheet> createState() =>
      _MedicationFormModalSheetState();
}

class _MedicationFormModalSheetState extends State<MedicationFormModalSheet> {
  final TextEditingController medicationNameController =
      TextEditingController();
  final TextEditingController PerDayController = TextEditingController();
  final TextEditingController DoseController = TextEditingController();
  List<TextEditingController> DayController =
      List.generate(5, (i) => TextEditingController());
  List<TextEditingController> dateContoller = List.generate(
      5,
      (i) => TextEditingController(
          text: DateFormat('HH:mm').format(DateTime.now())));
  FirebaseService? _firebaseService;
  final GlobalKey _formKey = GlobalKey<FormState>();
  int numRem = 1;
  double formHeight = 0;

  final FocusNode medicationNameFocus = FocusNode();
  final FocusNode DoseFocus = FocusNode();
  final FocusNode timePerDayFocus = FocusNode();

  @override
  void initState() {
    _firebaseService = GetIt.instance.get<FirebaseService>();
    super.initState();
  }

  @override
  void dispose() {
    medicationNameController.clear();
    DoseController.clear();
    PerDayController.clear();
    DayController = List.generate(5, (i) => TextEditingController());
    dateContoller = List.generate(
        5,
        (i) => TextEditingController(
            text: DateFormat('HH:mm').format(DateTime.now())));
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
      height: formHeight == 0 ? widget.deviceHeight * 0.55 : formHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 11.0),
            child: Text(
              textAlign: TextAlign.center,
              "medication_entry_title".tr(),
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
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: context.locale == Locale('en')
                        ? EdgeInsets.only(left: widget.deviceWidth * 0.1)
                        : EdgeInsets.only(right: widget.deviceWidth * 0.1),
                    child: Row(
                      children: [
                        FormInputField(
                          deviceHeight: widget.deviceHeight,
                          controller: medicationNameController,
                          deviceWidth: widget.deviceWidth + 100,
                          hintText: "medication_entry_medication_name".tr(),
                          keyboardType: TextInputType.text,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: context.locale == Locale('en')
                        ? EdgeInsets.only(
                            left: widget.deviceWidth * 0.1, top: 15)
                        : EdgeInsets.only(
                            right: widget.deviceWidth * 0.1, top: 15),
                    child: Row(
                      children: [
                        FormInputField(
                          deviceHeight: widget.deviceHeight,
                          controller: DoseController,
                          deviceWidth: widget.deviceWidth,
                          hintText: "medication_entry_medication_dose".tr(),
                          keyboardType: TextInputType.number,
                        ),
                        FormInputField(
                          deviceHeight: widget.deviceHeight,
                          controller: PerDayController,
                          deviceWidth: widget.deviceWidth,
                          hintText: "medication_entry_medication_per_day".tr(),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: context.locale == Locale('en')
                        ? EdgeInsets.only(
                            left: widget.deviceWidth * 0.1, top: 15)
                        : EdgeInsets.only(
                            right: widget.deviceWidth * 0.1, top: 15),
                    child: Row(
                      children: [
                        Text(
                          "medication_entry_reminders_max".tr(),
                        ),
                      ],
                    ),
                  ),
                  for (int i = 0; i < numRem; i++)
                    Padding(
                      padding: context.locale == Locale('en')
                          ? EdgeInsets.only(
                              left: widget.deviceWidth * 0.1, top: 4)
                          : EdgeInsets.only(
                              right: widget.deviceWidth * 0.1, top: 4),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            width: widget.deviceWidth * 0.35,
                            child: DropDown(
                                optionList: DayEnum.values
                                    .map((e) => e.toString().split(".")[1])
                                    .toList(),
                                height: 40,
                                width: 30,
                                hint: "medication_entry_medication_day".tr(),
                                textStyle: TextStyle(
                                  fontSize: 17,
                                  fontFamily: "DM_Sans",
                                ),
                                save: (value) => DayController[i].text = value),
                          ),
                          FormInputField(
                            deviceHeight: widget.deviceHeight,
                            controller: dateContoller[i],
                            deviceWidth: widget.deviceWidth,
                            hintText: "medication_entry_medication_time".tr(),
                            keyboardType: TextInputType.datetime,
                            readOnly: true,
                            onTap: () {
                              DatePicker.showDatePicker(
                                context,
                                dateFormat: 'HH:mm',
                                pickerMode: DateTimePickerMode.time,
                                initialDateTime: DateTime.now(),
                                onConfirm: (dateTime, selectedIndex) {
                                  String formattedDateTime =
                                      DateFormat('HH:mm').format(dateTime);
                                  dev.log(
                                      "Formatted Date Time: $formattedDateTime");
                                  setState(() {
                                    dateContoller[i].text = formattedDateTime;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
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
                      onPressed: () {
                        setState(() {
                          if (numRem < 5) {
                            numRem = numRem + 1;
                            formHeight = widget.deviceHeight * 0.55 +
                                (widget.deviceHeight * 0.055 * numRem);
                          }
                        });
                      },
                      child: Text(
                        "medication_entry_add_another_reminder".tr(),
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
                        Medication medicationData;
                        List<MedReminder> lmr = [];
                        for (int i = 0; i < numRem; i++) {
                          int.parse(dateContoller[i].text.split(":")[0]);
                          lmr.add(MedReminder(
                              DayEnum.values.byName(DayController[i].text),
                              TimeOfDay(
                                  hour: int.parse(
                                      dateContoller[i].text.split(":")[0]),
                                  minute: int.parse(
                                      dateContoller[i].text.split(":")[1]))));
                        }
                        MedReminders ml = MedReminders(lmr);
                        medicationData = Medication(
                            medicationNameController.text,
                            int.parse(DoseController.text),
                            int.parse(PerDayController.text),
                            ml);
                        await _firebaseService!
                            .saveMedicationData(medicationData);
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
          ),
        ],
      ),
    );
  }
}
