import 'package:flutter/material.dart';
import 'package:gluc_safe/Models/user.dart';

class ProfilePage extends StatelessWidget {
  GlucUser? _glucUser;
  double? _deviceHeight, _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _glucUser = ModalRoute.of(context)!.settings.arguments as GlucUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[400],
        title: const Text("Profile",
            style: TextStyle(
              color: Colors.black,
            )),
      ),
      body: Column(children: [
        Expanded(
          flex: 4,
          child: Container(
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    profileName(_glucUser!.firstName, _glucUser!.lastName),
                    profileAge(),
                    profileGender(),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            width: _deviceWidth,
            color: Colors.red,
            child: Text("Placeholder"),
          ),
        )
      ]),
    );
  }

  TextStyle dataTextStyle() {
    return const TextStyle(fontSize: 18, fontWeight: FontWeight.w400);
  }

  Widget profileName(String firstName, String lastName) {
    return profileWidget(
        const Icon(Icons.person),
        Text(
          "$firstName $lastName",
          style: dataTextStyle(),
        ));
  }

  Widget profileAge() {
    return profileWidget(
        const Icon(Icons.person),
        Text(
          "${_glucUser!.age.years}",
          style: dataTextStyle(),
        ));
  }

  Widget profileGender() {
    return profileWidget(
        const Icon(Icons.person),
        Text(
          "${_glucUser!.gender}",
          style: dataTextStyle(),
        ));
  }

  Widget profileWidget(Icon icon, Text textWidget) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
      child: Row(
        children: [
          icon,
          SizedBox(
            width: _deviceWidth! * 0.02,
          ),
          textWidget,
        ],
      ),
    );
  }
}
