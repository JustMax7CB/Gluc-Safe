import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavbarButton extends StatelessWidget {
  const NavbarButton({super.key, required this.icon, required this.onPressed});
  final Widget icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(8),
          side: BorderSide(width: 0.8, color: Colors.black),
          elevation: 1.5,
          backgroundColor: Colors.white,
          shape: CircleBorder(
            side: BorderSide(width: 0.8, color: Colors.black),
          ),
        ),
        onPressed: () => onPressed(),
        child: icon,
      ),
    );
  }
}
