import 'dart:developer' as dev;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceHeight, _deviceWidth;
  final _formkey = GlobalKey<FormState>();
  late String _email;
  late String _pass;
  FirebaseService? _firebaseService;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

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
                _formWidget(),
                dividerWidget(),
                signUpText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formWidget() {
    return Form(
      key: _formkey,
      child: formContainer(),
    );
  }

  Widget googleButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 1,
          foregroundColor: Colors.red),
      onPressed: () async {
        dev.log("Pressed Login by Google Account");
        await GoogleSignIn().signIn();
      },
      icon: const FaIcon(FontAwesomeIcons.google),
      label: const Text(
        "Login Using Google Account",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Future<void> checkLogin() async {
    bool _result = false;
    try {
      _result =
          await _firebaseService!.loginUser(email: _email, password: _pass);
    } on FirebaseAuthException catch (e) {
      dev.log("error is: $e");
      snackBarWithDismiss("Invalid user data");
    }
  }

  Widget formContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      width: _deviceWidth,
      height: _deviceHeight * 0.55,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Login",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          textField(
            "Email",
            "Enter your email address",
            "Email",
            const Icon(Icons.email_outlined),
            false,
          ),
          textField(
            "Password",
            "Enter your password",
            "Password",
            const Icon(Icons.security),
            true,
          ),
          signInButton(),
          CircularContainer(),
          googleButton(),
        ],
      ),
    );
  }

  Widget CircularContainer() {
    return Container(
      width: _deviceWidth * 0.06,
      height: _deviceWidth * 0.06,
      decoration: const ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(width: 1),
        ),
      ),
      child: const Center(
        child: Text(
          "OR",
          style: TextStyle(fontSize: 10),
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
          onPressed: () => Navigator.popAndPushNamed(context, "/register"),
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

  Widget signInButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            snackBarWithDismiss("Checking Data...");
            checkLogin();
          }
        },
        child: const Text("Sign In"),
      ),
    );
  }

  snackBarWithDismiss(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            // Hide the snackbar before its duration ends
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
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

  Widget textField(
      String field, String hint, String label, Icon icon, bool obscure) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          filled: true,
          icon: icon,
          hintStyle: const TextStyle(fontSize: 13),
          hintText: hint,
          labelText: label),
      onChanged: (String val) {
        (field == "Email") ? _email = val : _pass = val;
      },
      obscureText: obscure,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return "$field cannot be empty";
        }
        return null;
      },
    );
  }
}
