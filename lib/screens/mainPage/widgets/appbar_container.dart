import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gluc_safe/screens/mainPage/widgets/appbar_details.dart';
import 'package:gluc_safe/widgets/textStroke.dart';

class AppbarContainer extends StatelessWidget {
  const AppbarContainer({super.key, required this.func, required this.glucoseLatest, required this.glucoseAverage});
  final Function func;
  final double glucoseLatest;
  final double glucoseAverage;

  @override
  Widget build(BuildContext context) {
    double _deviceWidth = MediaQuery.of(context).size.width;
    double _deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 0.6, color: Colors.black)),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.centerRight,
          colors: [
            Color.fromRGBO(88, 180, 97, 1),
            Color.fromRGBO(58, 170, 96, 1),
          ],
        ),
      ),
      padding: EdgeInsets.only(top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: _deviceWidth * 0.88,
                child: Center(
                  child: Text(
                    "main_page_appbar_title".tr(),
                    style: TextStyle(
                      fontFamily: "DM_Sans",
                      fontSize: 45,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(255, 255, 255, 1),
                      shadows: <Shadow>[
                        Shadow(
                          color: Color.fromRGBO(0, 0, 0, 0.6),
                          blurRadius: 0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: _deviceWidth * 0.12,
                child: IconButton(
                  onPressed: () {
                    debugPrint("Hamburger button pressed");
                    func();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppbarDetailsContainer(
                  valueType: "Latest",
                  glucoseValue: glucoseLatest,
                  width: 130,
                  height: 56),
              AppbarDetailsContainer(
                  valueType: "Average",
                  glucoseValue: glucoseAverage,
                  width: 130,
                  height: 56),
            ],
          ),
        ],
      ),
    );
  }
}
