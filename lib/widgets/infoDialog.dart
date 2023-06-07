import 'package:flutter/material.dart';
import 'package:gluc_safe/widgets/textStroke.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({
    super.key,
    required this.title,
    required this.details,
    required this.height,
    required this.width,
  });
  final String title;
  final String details;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromRGBO(211, 229, 214, 1),
          border: Border.all(
            color: Color.fromRGBO(82, 179, 98, 1),
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 24,
                  fontFamily: "DM_Sans",
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(34, 163, 63, 1),
                  shadows: textStroke(0.5, Colors.black),
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Text(
                textAlign: TextAlign.center,
                details,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: "DM_Sans",
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
