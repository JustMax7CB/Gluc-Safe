import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MedicationAppBar extends StatelessWidget {
  const MedicationAppBar({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
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
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: context.locale == const Locale('en')
                    ? EdgeInsets.only(left: width * 0.14)
                    : EdgeInsets.only(right: width * 0.14),
                child: Center(
                  child: Text(
                    "medication_page_title".tr(),
                    style: const TextStyle(
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
            ],
          ),
        ],
      ),
    );
  }
}
