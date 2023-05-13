import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MedicationPageDrawer extends StatelessWidget {
  const MedicationPageDrawer({super.key, required this.ChangeLanguage});

  final Function ChangeLanguage;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(top: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Color.fromARGB(0, 255, 255, 255),
              ),
              onPressed: () => ChangeLanguage(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: context.locale == Locale('en')
                          ? const EdgeInsets.only(right: 8.0)
                          : const EdgeInsets.only(left: 8.0),
                      child: Image.asset(
                        "lib/assets/icons_svg/globe_lang.png",
                        height: 35,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "main_page_drawer_change_language".tr(),
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
