import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:gluc_safe/widgets/textStroke.dart';
import 'dart:developer' as dev;

void showEmergencyDialog(
    BuildContext context, Map contactDetails, double width) {
  AwesomeDialog(
    borderSide: BorderSide(
      color: Color.fromRGBO(82, 179, 98, 1),
      width: 3,
    ),
    barrierColor: Colors.amber,
    dialogBackgroundColor: Color.fromRGBO(211, 229, 214, 1),
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    context: context,
    animType: AnimType.topSlide,
    dialogType: DialogType.warning,
    dismissOnTouchOutside: true,
    body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "emergency_call_title".tr(),
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            fontFamily: "DM_Sans",
            color: Color.fromRGBO(34, 163, 63, 1),
            shadows: []..addAll(
                textStroke(0.5, Colors.black),
              ),
          ),
        ),
        Text(
          "emergency_call_who_call".tr(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontFamily: "DM_Sans",
            color: Color.fromRGBO(34, 163, 63, 1),
            shadows: []..addAll(
                textStroke(0.5, Colors.black),
              ),
          ),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            fixedSize: Size(width * 0.35, double.infinity),
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
            await FlutterPhoneDirectCaller.callNumber(contactDetails['phone']);
            dev.log("Call Contact ${contactDetails['phone']}");
          },
          child: Text(
            "emergency_call_contact".tr(args: [contactDetails['name']]),
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
            fixedSize: Size(width * 0.35, double.infinity),
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
            await FlutterPhoneDirectCaller.callNumber('101');
            dev.log("Call ambulance");
          },
          child: Text(
            "emergency_call_ambulance".tr(),
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "emergency_call_tap_outside".tr(),
            style: TextStyle(
              fontSize: 12,
              fontFamily: "DM_Sans",
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ),
  ).show();
}
