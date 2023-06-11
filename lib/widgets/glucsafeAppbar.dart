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
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            "login_page_glucsafe_title".tr(),
            style: Theme.of(context).textTheme.headlineLarge,
          )
        ],
      ),
    ),
    centerTitle: true,
    flexibleSpace: ClipPath(
      clipper: CustomAppBar(),
      child: Container(
        decoration: BoxDecoration(
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
