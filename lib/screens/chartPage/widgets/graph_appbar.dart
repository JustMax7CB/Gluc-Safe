import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gluc_safe/screens/mainPage/widgets/appbar_details.dart';
import 'package:gluc_safe/widgets/textStroke.dart';

class GraphAppBar extends StatelessWidget {
  const GraphAppBar({super.key, required this.changeLanguage});
  final Function changeLanguage;

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
              Padding(
                padding: context.locale == Locale('en')
                    ? EdgeInsets.only(left: _deviceWidth * 0.14)
                    : EdgeInsets.only(right: _deviceWidth * 0.14),
                child: Center(
                  child: Text(
                    "main_page_glucose_graph".tr(),
                    style: TextStyle(
                      fontFamily: "DM_Sans",
                      fontSize: 40,
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
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
