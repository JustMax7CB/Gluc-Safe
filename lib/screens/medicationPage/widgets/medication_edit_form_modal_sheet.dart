import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/Models/enums/days.dart';
import 'package:gluc_safe/Models/med_reminder.dart';
import 'package:gluc_safe/Models/medications.dart';
import 'package:gluc_safe/screens/mainPage/widgets/form_input_field.dart';
import 'package:gluc_safe/screens/medicationPage/Medications.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/widgets/dropdown.dart';
import 'package:gluc_safe/widgets/textStroke.dart';
import 'dart:developer' as dev;

class MedicationEditFormModalSheet extends StatefulWidget {
  const MedicationEditFormModalSheet(
      {super.key,
      required this.medication,
      required this.deviceHeight,
      required this.deviceWidth});

  final double deviceHeight;
  final double deviceWidth;
  final Medication medication;

  @override
  State<MedicationEditFormModalSheet> createState() =>
      _MedicationEditFormModalSheetState();
}

class _MedicationEditFormModalSheetState
    extends State<MedicationEditFormModalSheet> {
  final TextEditingController doseController = TextEditingController();
  double formHeight = 0;
  int numRem = 1;
  final TextEditingController perDayController = TextEditingController();
  List<TextEditingController> reminderDayController =
      List.generate(5, (i) => TextEditingController());

  List<TextEditingController> reminderTimeContoller =
      List.generate(5, (i) => TextEditingController());

  FirebaseService? _firebaseService;
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _firebaseService = GetIt.instance.get<FirebaseService>();

    doseController.text = widget.medication.numOfPills.toString();
    perDayController.text = widget.medication.perDay.toString();
    numRem = widget.medication.reminders.reminders.length;
    List reminderList = widget.medication.reminders.reminders;
    formHeight =
        widget.deviceHeight * 0.55 + (widget.deviceHeight * 0.055 * numRem);
    for (int i = 0; i < numRem; i++) {
      reminderDayController[i].text =
          reminderList[i].day.toString().split(".").last;
      reminderTimeContoller[i].text =
          "${reminderList[i].time.hour}:${reminderList[i].time.minute}";
    }
  }

  Future<bool> editMedicationData() async {
    try {
      // Medication medicationData;
      List<MedReminder> lmr = [];
      for (int i = 0; i < numRem; i++) {
        List timeListString = reminderTimeContoller[i].text.split(":");
        lmr.add(MedReminder(
          DayEnum.values.byName(
              dayToString(reminderDayController[i].text, const Locale('en'))!),
          TimeOfDay(
              hour: int.parse(timeListString[0]),
              minute: int.parse(timeListString[1])),
        ));
      }
      MedReminders ml = MedReminders(lmr);
      // medicationData = Medication(widget.medication.medicationName,
      //     int.parse(doseController.text), int.parse(perDayController.text), ml);

      bool result = await _firebaseService!.editMedicationData(
          medicationName: widget.medication.medicationName,
          numOfPills: int.parse(doseController.text),
          perDay: int.parse(perDayController.text),
          reminders: ml);
      return result;
    } catch (e) {
      dev.log(e.toString());
      return false;
    }
  }

  updateMedicationDataOnPage() {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MedicationPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromRGBO(50, 108, 65, 1),
              width: 5,
              style: BorderStyle.solid),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(34),
            topRight: Radius.circular(34),
          ),
          color: const Color.fromRGBO(211, 229, 214, 1)),
      height: formHeight == 0 ? widget.deviceHeight * 0.55 : formHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 11.0),
            child: Text(
              textAlign: TextAlign.center,
              "medication_edit".tr(),
              style: TextStyle(
                fontFamily: "DM_Sans",
                color: const Color.fromRGBO(89, 180, 98, 1),
                fontSize: 35,
                fontWeight: FontWeight.w600,
                shadows: <Shadow>[
                  const Shadow(
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                  ),
                  ...textStroke(
                    0.7,
                    const Color.fromRGBO(0, 0, 0, 1),
                  ),
                ],
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  widget.medication.medicationName,
                  style: TextStyle(
                    fontFamily: "DM_Sans",
                    color: const Color.fromRGBO(89, 180, 98, 1),
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                    shadows: <Shadow>[
                      const Shadow(
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                      ),
                      ...textStroke(
                        0.7,
                        const Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: context.locale == const Locale('en')
                      ? EdgeInsets.only(left: widget.deviceWidth * 0.1, top: 15)
                      : EdgeInsets.only(
                          right: widget.deviceWidth * 0.1, top: 15),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "medication_entry_medication_dose".tr(),
                              style: const TextStyle(
                                  fontFamily: "DM_Sans",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          FormInputField(
                            deviceHeight: widget.deviceHeight,
                            controller: doseController,
                            deviceWidth: widget.deviceWidth,
                            hintText: "medication_entry_medication_dose".tr(),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "medication_entry_medication_per_day".tr(),
                              style: const TextStyle(
                                  fontFamily: "DM_Sans",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          FormInputField(
                            deviceHeight: widget.deviceHeight,
                            controller: perDayController,
                            deviceWidth: widget.deviceWidth,
                            hintText:
                                "medication_entry_medication_per_day".tr(),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: context.locale == const Locale('en')
                      ? EdgeInsets.only(
                          left: widget.deviceWidth * 0.12, top: 15)
                      : EdgeInsets.only(
                          right: widget.deviceWidth * 0.12, top: 15),
                  child: Row(
                    children: [
                      Text(
                        "medication_entry_reminders_max".tr(),
                        style: const TextStyle(
                            fontFamily: "DM_Sans",
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                for (int i = 0; i < numRem; i++)
                  Padding(
                    padding: context.locale == const Locale('en')
                        ? EdgeInsets.only(
                            left: widget.deviceWidth * 0.1, top: 4)
                        : EdgeInsets.only(
                            right: widget.deviceWidth * 0.1, top: 4),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          width: widget.deviceWidth * 0.35,
                          child: DropDown(
                              value: (i <
                                      widget.medication.reminders.reminders
                                          .length)
                                  ? dayToString(reminderDayController[i].text,
                                      context.locale)
                                  : null,
                              optionList: daysEnumToString(context.locale),
                              height: 40,
                              width: 30,
                              hint: "medication_entry_medication_day".tr(),
                              textStyle: const TextStyle(
                                fontSize: 17,
                                fontFamily: "DM_Sans",
                              ),
                              save: (value) =>
                                  reminderDayController[i].text = value),
                        ),
                        FormInputField(
                          deviceHeight: widget.deviceHeight,
                          controller: reminderTimeContoller[i],
                          deviceWidth: widget.deviceWidth,
                          hintText: "medication_entry_medication_time".tr(),
                          keyboardType: TextInputType.datetime,
                          readOnly: true,
                          onTap: () {
                            DatePicker.showDatePicker(
                              locale: DateTimePickerLocale.en_us,
                              minuteDivider: 5,
                              pickerTheme: DateTimePickerTheme(
                                cancel: Text(
                                  "misc_cancel".tr(),
                                  style: TextStyle(
                                      fontFamily: "DM_Sans",
                                      color:
                                          const Color.fromRGBO(89, 180, 98, 1),
                                      shadows: [
                                        ...textStroke(0.1, Colors.black)
                                      ]),
                                ),
                                confirm: Text(
                                  "misc_confirm".tr(),
                                  style: TextStyle(
                                      fontFamily: "DM_Sans",
                                      color:
                                          const Color.fromRGBO(89, 180, 98, 1),
                                      shadows: [
                                        ...textStroke(0.1, Colors.black)
                                      ]),
                                ),
                              ),
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
                                  reminderTimeContoller[i].text =
                                      formattedDateTime;
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                          backgroundColor: const Color.fromRGBO(58, 170, 96, 1),
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
                          "medication_entry_add_reminder".tr(),
                          style: const TextStyle(
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                          backgroundColor: const Color.fromRGBO(58, 170, 96, 1),
                        ),
                        onPressed: () {
                          setState(() {
                            if (numRem > 1) {
                              numRem = numRem - 1;
                              formHeight = widget.deviceHeight * 0.55 +
                                  (widget.deviceHeight * 0.055 * numRem);
                            }
                          });
                        },
                        child: Text(
                          "medication_entry_remove_reminder".tr(),
                          style: const TextStyle(
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
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      backgroundColor: const Color.fromRGBO(58, 170, 96, 1),
                    ),
                    onPressed: () async {
                      if (await editMedicationData()) {
                        if (mounted) {
                          updateMedicationDataOnPage();
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("medication_edit_error".tr()),
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: "misc_snackbar_dismiss".tr(),
                                onPressed: () {
                                  // Hide the snackbar before its duration ends
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                },
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      "misc_save".tr(),
                      style: const TextStyle(
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
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    backgroundColor: const Color.fromRGBO(58, 170, 96, 1),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "misc_cancel".tr(),
                    style: const TextStyle(
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
