import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'customAppBar.dart';

AppBar glucSafeAppbar(BuildContext context, double deviceHeight) {
  return AppBar(
    backgroundColor: Colors.transparent,
    toolbarHeight: 140,
    elevation: 0.0,
    title: Container(
      margin: EdgeInsets.only(bottom: deviceHeight * 0.037),
      child: Column(
        children: [
          Text(
            "login_page_welcome_title".tr(),
            style: welcomeTextStyle(),
          ),
          Text(
            "login_page_glucsafe_title".tr(),
            style: glucSafeTextStyle(),
          )
        ],
      ),
    ),
    centerTitle: true,
    flexibleSpace: ClipPath(
      clipper: CustomAppBar(),
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color.fromRGBO(89, 200, 98, 1),
              Color.fromRGBO(59, 190, 65, 1)
            ])),
      ),
    ),
  );
}

TextStyle welcomeTextStyle() {
  return const TextStyle(
    fontFamily: "DM_Sans",
    fontSize: 28,
    fontWeight: FontWeight.w500,
    shadows: <Shadow>[
      Shadow(
        color: Color.fromRGBO(0, 0, 0, 0.6),
        blurRadius: 0,
        offset: Offset(0, 3),
      ),
    ],
  );
}

TextStyle glucSafeTextStyle() {
  return const TextStyle(
    fontFamily: "DM_Sans",
    fontSize: 50,
    fontWeight: FontWeight.w500,
    shadows: <Shadow>[
      Shadow(
        color: Color.fromRGBO(0, 0, 0, 0.6),
        blurRadius: 0,
        offset: Offset(0, 3),
      ),
    ],
  );
}
