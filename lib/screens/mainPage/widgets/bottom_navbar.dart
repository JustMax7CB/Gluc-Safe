import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gluc_safe/screens/mainPage/widgets/navbar_button.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar(
      {super.key,
      this.logout,
      this.emergency,
      required this.deviceWidth,
      required this.deviceHeight});
  final Function? logout;
  final Function? emergency;
  final double deviceWidth, deviceHeight;

  @override
  Widget build(BuildContext context) {
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
      width: deviceWidth,
      padding: EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: logout != null
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.end,
        children: [
          if (logout != null)
            NavbarButton(
                deviceHeight: deviceHeight,
                deviceWidth: deviceWidth,
                icon: SvgPicture.asset("lib/assets/icons_svg/logout_icon.svg"),
                onPressed: () => logout!()),
          if (emergency != null)
            NavbarButton(
                deviceHeight: deviceHeight,
                deviceWidth: deviceWidth,
                icon:
                    SvgPicture.asset("lib/assets/icons_svg/emergency_call.svg"),
                onPressed: () => emergency!())
        ],
      ),
    );
  }
}
