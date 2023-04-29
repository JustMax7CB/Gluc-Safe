import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/screens/mainPage/widgets/bottom_navbar.dart';
import 'package:gluc_safe/screens/mainPage/widgets/card_button.dart';
import 'package:gluc_safe/screens/mainPage/widgets/drawer.dart';
import 'package:gluc_safe/screens/mainPage/widgets/glucose_form_modal_sheet.dart';
import 'package:gluc_safe/screens/mainPage/widgets/weight_form_modal_sheet.dart';
import 'package:gluc_safe/screens/mainPage/widgets/workout_form_modal_sheet.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/Models/user.dart';
import 'dart:developer' as dev;
import 'package:gluc_safe/screens/mainPage/widgets/appbar_container.dart';
import '../pdf_preview.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late double _deviceWidth, _deviceHeight;
  FirebaseService? _firebaseService;
  GlucUser? _glucUser;
  GlucUser nullUser = GlucUser("", "", DateTime.now(), 0, "", "", "", "");

  TextEditingController glucoseController = TextEditingController();
  TextEditingController carbsController = TextEditingController();
  TextEditingController dateContoller = TextEditingController(
      text: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()));
  TextEditingController mealController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    getGlucUser();
    glucosePdfData();
  }

  Future<GlucUser> getGlucUser() async {
    String uid = _firebaseService!.user.uid;

    Map userData = await _firebaseService!.getUserData() as Map;
    var timestamp = userData['birthdate'].seconds;
    DateTime birthDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    GlucUser user = GlucUser(
        userData['firstName'],
        userData['lastName'],
        birthDate,
        userData['height'],
        userData['gender'],
        userData['mobile'],
        userData['contactName'],
        userData['contactNumber']);
    _glucUser = user;
    return user;
  }

  Future<List> glucosePdfData() async {
    List? glucoseData = await _firebaseService!.getGlucoseData();
    if (glucoseData != null) {
      glucoseData = glucoseData
          .map((e) => [
                DateTime.fromMillisecondsSinceEpoch(e['Date']),
                e['Glucose'].toString()
              ])
          .toList();
      return glucoseData;
    }
    return [];
  }

  Future<Map> getGlucoseAverageLatest() async {
    List? glucoseData = await _firebaseService!.getGlucoseData();
    num average = 0;
    Map glucoseLatestAndAverage = {'Latest': 0, 'Average': 0};
    if (glucoseData != null) {
      glucoseData = glucoseData.map((e) => e['Glucose']).toList();
      glucoseLatestAndAverage['Latest'] = glucoseData.last.toDouble();
      average = glucoseData.reduce((value, element) => value + element);
      average = average / glucoseData.length;
      glucoseLatestAndAverage['Average'] = average;
    }
    return glucoseLatestAndAverage;
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      endDrawer: MainDrawer(
        ChangeLanguage: () {
          if (context.locale == Locale('en'))
            context.setLocale(Locale('he'));
          else
            context.setLocale(Locale('en'));
        },
        exportPDF: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FutureBuilder(
                future: glucosePdfData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return PdfPreviewPage(
                        locale: context.locale,
                        name: '${_glucUser!.firstName} ${_glucUser!.lastName}',
                        glucoseValues: snapshot.data as List);
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        logout: _firebaseService!.logout,
        emergency: () => dev.log("Emergency Pressed"),
      ),
      appBar: AppBar(
        actions: [Container()],
        automaticallyImplyLeading: false,
        toolbarHeight: _deviceHeight * 0.22,
        flexibleSpace: FutureBuilder(
          future: getGlucoseAverageLatest(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AppbarContainer(
                glucoseAverage: (snapshot.data as Map)['Average'],
                glucoseLatest: (snapshot.data as Map)['Latest'],
                func: () => Scaffold.of(context).openEndDrawer(),
              );
            } else {
              return AppbarContainer(
                glucoseAverage: 0,
                glucoseLatest: 0,
                func: () => Scaffold.of(context).openEndDrawer(),
              );
            }
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        width: _deviceWidth,
        height: _deviceHeight * 0.62,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder(
              future: getGlucUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "main_page_appbar_welcome".tr(args: [_glucUser!.firstName]),
                    style: TextStyle(
                      fontFamily: "DM_Sans",
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(89, 180, 98, 1),
                    ),
                  );
                } else {
                  return Text("");
                }
              },
            ),
            Container(
              height: _deviceHeight * 0.37,
              margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.32,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  CardButton(
                    onTap: () => showModalBottomSheet(
                      isScrollControlled: true,
                      isDismissible: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(34),
                          topRight: Radius.circular(34),
                        ),
                      ),
                      context: context,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: GlucoseFormModalSheet(),
                      ),
                    ),
                    title: "main_page_add_glucose".tr(),
                    icon: SvgPicture.asset(
                        "lib/assets/icons_svg/glucose_meter.svg",
                        height: 95),
                  ),
                  CardButton(
                    onTap: () {
                      dev.log("add medicine button pressed");
                    },
                    title: "main_page_add_medicine".tr(),
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 35.0),
                      child: SvgPicture.asset(
                          "lib/assets/icons_svg/medicine_icon.svg",
                          height: 30),
                    ),
                  ),
                  CardButton(
                    onTap: () => showModalBottomSheet(
                      isScrollControlled: true,
                      isDismissible: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(34),
                          topRight: Radius.circular(34),
                        ),
                      ),
                      context: context,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: WeightFormModalSheet(),
                      ),
                    ),
                    title: "main_page_add_weight".tr(),
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SvgPicture.asset(
                          "lib/assets/icons_svg/scale_icon.svg",
                          height: 65),
                    ),
                  ),
                  CardButton(
                    onTap: () => showModalBottomSheet(
                      isScrollControlled: true,
                      isDismissible: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(34),
                          topRight: Radius.circular(34),
                        ),
                      ),
                      context: context,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: WorkoutFormModalSheet(),
                      ),
                    ),
                    title: "main_page_add_workout".tr(),
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: SvgPicture.asset(
                          "lib/assets/icons_svg/dumbbell_icon.svg",
                          height: 50),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: CardButton(
                  onTap: () {
                    Navigator.pushNamed(context, '/chart');
                  },
                  width: _deviceWidth,
                  title: "main_page_glucose_graph".tr(),
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: SvgPicture.asset("lib/assets/icons_svg/graph.svg",
                        height: 60),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
