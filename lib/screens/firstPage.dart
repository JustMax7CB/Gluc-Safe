import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late double _deviceHeight, _deviceWidth;
  final _formkey = GlobalKey<FormState>();
  late String _email;
  late String _pass;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        elevation: 1,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                titleWidget(),
                buttons(),
                dividerWidget(),
                signUpText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emailButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          elevation: 1,
          foregroundColor: Colors.white),
      onPressed: () => Navigator.popAndPushNamed(context, "/login"),
      child: const Text(
        "Using Email and password",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget googleButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 1,
          foregroundColor: Colors.red),
      onPressed: () async {
        print("Pressed Login by Google Account");
        await GoogleSignIn().signIn();
        Navigator.pop(context);
      },
      icon: const FaIcon(FontAwesomeIcons.google),
      label: const Text(
        "Using Google Account",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget buttons() {
    return Padding(
      padding: EdgeInsets.only(
          top: _deviceHeight * 0.15, bottom: _deviceHeight * 0.1),
      child: SizedBox(
        height: _deviceHeight * 0.2,
        width: _deviceWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            emailButton(),
            googleButton(),
          ],
        ),
      ),
    );
  }

  Widget signUpText() {
    return Column(
      children: [
        const Text("Doesn't Have an account?"),
        TextButton(
          child: const Text(
            "Sign up",
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () => Navigator.pushNamed(context, "/register"),
        ),
      ],
    );
  }

  Widget dividerWidget() {
    return const Divider(
      height: 20,
      thickness: 2,
      indent: 70,
      endIndent: 70,
      color: Colors.grey,
    );
  }

  Widget titleWidget() {
    return SizedBox(
      width: _deviceWidth,
      height: _deviceHeight * 0.2,
      child: Center(child: titleText()),
    );
  }

  Widget titleText() {
    return const Text(
      "Gluc-Safe",
      style: TextStyle(
        fontFamily: "BebasNeue",
        fontSize: 65,
        fontWeight: FontWeight.w400,
        letterSpacing: 2,
        fontStyle: FontStyle.normal,
      ),
    );
  }
}
