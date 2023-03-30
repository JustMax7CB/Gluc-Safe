import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gluc_safe/screens/mainPage/widgets/navbar_button.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar(
      {super.key, required this.logout, required this.emergency});
  final Function logout;
  final Function emergency;

  @override
  Widget build(BuildContext context) {
    double _deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(89, 180, 98, 1),
            Color.fromRGBO(74, 148, 81, 1),
          ],
        ),
      ),
      width: _deviceWidth,
      padding: EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NavbarButton(
              icon: SvgPicture.asset("lib/assets/icons_svg/logout_icon.svg"),
              onPressed: () => logout()),
          NavbarButton(
              icon: SvgPicture.asset("lib/assets/icons_svg/emergency_call.svg"),
              onPressed: () => emergency())
        ],
      ),
    );
  }
}
