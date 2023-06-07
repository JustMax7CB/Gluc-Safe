import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer(
      {super.key,
      required this.ChangeLanguage,
      required this.exportPDF,
      required this.height});

  final Function ChangeLanguage;
  final Function exportPDF;
  final double height;

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
                        height: height * 0.04,
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
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Color.fromARGB(0, 255, 255, 255),
              ),
              onPressed: () {
                Scaffold.of(context).closeEndDrawer();
                exportPDF();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: context.locale == Locale('en')
                          ? const EdgeInsets.only(right: 8.0)
                          : const EdgeInsets.only(left: 8.0),
                      child: SvgPicture.asset(
                          "lib/assets/icons_svg/page-export-pdf.svg",
                          height: height * 0.04),
                    ),
                    Text(
                      "main_page_drawer_pdf".tr(),
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
