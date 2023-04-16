import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gluc_safe/widgets/textStroke.dart';

void showGlucoseWarningDialog(BuildContext context, Function confirm,
    Function cancel, String title, String message) {
  AwesomeDialog(
    barrierColor: Colors.amber,
    dialogBackgroundColor: Color.fromRGBO(211, 229, 214, 1),
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    context: context,
    animType: AnimType.topSlide,
    dialogType: DialogType.warning,
    dismissOnTouchOutside: false,
    btnOk: OutlinedButton(
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
      onPressed: () => confirm(),
      child: Text(
        "misc_confirm".tr(),
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
    btnCancel: OutlinedButton(
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
      onPressed: () => cancel(),
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
    title: title,
    titleTextStyle: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w800,
        fontFamily: "DM_Sans",
        color: Color.fromRGBO(34, 163, 63, 1),
        shadows: []..addAll(
            textStroke(0.2, Colors.black),
          )),
    desc: message,
    descTextStyle: TextStyle(
      fontSize: 16,
      fontFamily: "DM_Sans",
    ),
  ).show();
}
