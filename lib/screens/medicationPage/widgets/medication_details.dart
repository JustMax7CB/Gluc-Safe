import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/Models/MedReminder.dart';
import 'package:gluc_safe/Models/medications.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:gluc_safe/screens/mainPage/widgets/bottom_navbar.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/services/deviceQueries.dart';
import 'package:gluc_safe/widgets/emergencyDialog.dart';
import 'package:gluc_safe/widgets/textStroke.dart';

class MedicationDetails extends StatefulWidget {
  const MedicationDetails({super.key, required this.medication});
  final Medication medication;

  @override
  State<MedicationDetails> createState() => _MedicationDetailsState();
}

class _MedicationDetailsState extends State<MedicationDetails> {
  double? _deviceWidth;
  double? _deviceHeight;
  late FirebaseService firebaseService;
  GlucUser? _glucUser;
  List<MedReminder>? reminders;

  @override
  void initState() {
    super.initState();
    firebaseService = GetIt.instance.get<FirebaseService>();
    getGlucUser();
    reminders = widget.medication.reminders.reminders;
  }

  Future<GlucUser> getGlucUser() async {
    Map userData = await firebaseService.getUserData() as Map;
    var timestamp = userData['birthdate'].seconds;
    DateTime birthDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    GlucUser user = GlucUser(
        userData['firstName'],
        userData['lastName'],
        birthDate,
        userData['height'],
        userData['gender'],
        userData['mobile'],
        userData['contactName'],
        userData['contactNumber']);
    _glucUser = user;
    return user;
  }

  @override
  Widget build(BuildContext context) {
    if (_deviceWidth == null || _deviceHeight == null) {
      _deviceWidth = getDeviceWidth(context);
      _deviceHeight = getDeviceHeight(context);
    }

    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        deviceHeight: _deviceHeight!,
        deviceWidth: _deviceWidth!,
        emergency: () => showEmergencyDialog(
            context,
            {'name': _glucUser!.contactName, 'phone': _glucUser!.contactNum},
            _deviceWidth!),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset(
                "lib/assets/icons_svg/Carret_Left.svg",
                height: _deviceHeight! * 0.07,
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: _deviceHeight! * 0.06),
                      padding: EdgeInsets.all(_deviceWidth! * 0.05),
                      height: _deviceHeight! * 0.5,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: _deviceHeight! * 0.5,
                          crossAxisCount: 2,
                          childAspectRatio: 2.0,
                        ),
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // First element, takes half of the width and the entire height
                            return Container(
                              width: _deviceWidth! / 2,
                              height: double.infinity,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Image.asset(
                                    "lib/assets/icons_svg/pills_image.png"),
                              ),
                            );
                          } else {
                            // Other three elements, share the remaining half width and the entire height
                            return Container(
                              alignment: Alignment.topCenter,
                              width: double.infinity / 2,
                              height: double.infinity / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: _deviceHeight! * 0.04),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "medication_details_page_medication_name"
                                                .tr(),
                                            style: TextStyle(
                                                fontFamily: "DM_Sans",
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    134, 134, 134, 1)),
                                          ),
                                          Text(
                                            widget.medication.medicationName,
                                            style: TextStyle(
                                              fontFamily: "DM_Sans",
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(
                                                  89, 180, 98, 1),
                                            ),
                                          ),
                                        ]),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: _deviceHeight! * 0.04),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "medication_details_page_medication_dose"
                                                .tr(),
                                            style: TextStyle(
                                                fontFamily: "DM_Sans",
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    134, 134, 134, 1)),
                                          ),
                                          Text(
                                            "medication_details_page_medication_pills"
                                                .tr(args: [
                                              widget.medication.numOfPills
                                                  .toString()
                                            ]),
                                            style: TextStyle(
                                              fontFamily: "DM_Sans",
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(
                                                  89, 180, 98, 1),
                                            ),
                                          )
                                        ]),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: _deviceHeight! * 0.04),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "medication_details_page_medication_per_day"
                                                .tr(),
                                            style: TextStyle(
                                                fontFamily: "DM_Sans",
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    134, 134, 134, 1)),
                                          ),
                                          Text(
                                            "medication_details_page_medication_times"
                                                .tr(args: [
                                              widget.medication.perDay
                                                  .toString()
                                            ]),
                                            style: TextStyle(
                                              fontFamily: "DM_Sans",
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(
                                                  89, 180, 98, 1),
                                            ),
                                          )
                                        ]),
                                  )
                                ],
                              ),
                            );
                          }
                        },
                      )),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Center(
                            child: Text(
                              "medication_details_page_medication_reminders"
                                  .tr(),
                              style: TextStyle(
                                  fontFamily: "DM_Sans",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(122, 119, 119, 1)),
                            ),
                          ),
                        ),
                        for (MedReminder reminder in reminders!)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                reminder.day.toString().split(".").last,
                                style: TextStyle(
                                    fontFamily: "DM_Sans",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(122, 119, 119, 1)),
                              ),
                              Text(
                                "${reminder.time.hour}:${reminder.time.minute}",
                                style: TextStyle(
                                    fontFamily: "DM_Sans",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(122, 119, 119, 1)),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: _deviceHeight! * 0.06),
                    width: _deviceWidth! * 0.6,
                    height: _deviceHeight! * 0.06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45),
                            side: BorderSide(width: 0.1),
                          ),
                          backgroundColor: Color.fromRGBO(88, 180, 97, 1)),
                      onPressed: () {},
                      child: Text(
                        "medication_details_page_medication_edit".tr(),
                        style: TextStyle(
                          fontFamily: "DM_Sans",
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(color: Colors.black12, offset: Offset(2, 2))
                          ]..addAll(
                              textStroke(0.2, Colors.black),
                            ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
