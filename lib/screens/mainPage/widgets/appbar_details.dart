import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppbarDetailsContainer extends StatelessWidget {
  const AppbarDetailsContainer(
      {super.key,
      required this.valueType,
      required this.glucoseValue,
      required this.width,
      required this.height});
  final String valueType;
  final num glucoseValue;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      width: width,
      height: height,
      decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.black),
          borderRadius: BorderRadius.circular(25),
          boxShadow: <BoxShadow>[
            BoxShadow(
                blurRadius: 3,
                offset: Offset(3, 3),
                color: Color.fromRGBO(0, 0, 0, 0.25))
          ],
          color: Color.fromRGBO(94, 166, 61, 1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "main_page_appbar_glucose_title".tr(args: [valueType]),
            style: TextStyle(
              fontFamily: "DM_Sans",
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
          Text(
            "main_page_appbar_glucose_average_value"
                .tr(args: [glucoseValue.toStringAsFixed(1)]),
            style: TextStyle(
              fontFamily: "DM_Sans",
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        ],
      ),
    );
  }
}
