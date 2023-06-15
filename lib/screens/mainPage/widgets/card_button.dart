import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final String title;
  final Widget icon;
  double? width;
  double? height;
  final Function onTap;

  CardButton(
      {super.key,
      required this.title,
      required this.icon,
      this.width,
      this.height,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(width: 0.8, color: Colors.black),
          color: const Color.fromRGBO(245, 245, 245, 1),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 3,
              offset: Offset(3, 3),
            )
          ],
        ),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: "DM_Sans",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(89, 180, 98, 1),
                ),
              ),
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
