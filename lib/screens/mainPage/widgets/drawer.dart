import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer(
      {super.key, required this.ChangeLanguage, required this.exportPDF});

  final Function ChangeLanguage;
  final Function exportPDF;

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
              child: Text(
                "main_page_drawer_change_language".tr(),
                style: TextStyle(fontSize: 20, color: Colors.black),
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
              child: Text(
                "main_page_drawer_pdf".tr(),
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
