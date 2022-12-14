import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:gluc_safe/services/database.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHeight, _deviceWidth;
  final _formkey = GlobalKey<FormState>();
  late String _email;
  late String _pass;
  late String _confirmPass;
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
        elevation: 0,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            color: Colors.amber[100],
            child: SingleChildScrollView(
              child: Column(
                children: [
                  titleWidget(),
                  Form(
                    key: _formkey,
                    child: formWidget(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future checkRegistration() async {
    if (_pass == _confirmPass) {
      try {
        await _firebaseService!.registerUser(email: _email, password: _pass);
      } on FirebaseAuthException catch (e) {
        snackBarWithDismiss('Invalid user data');
      } finally {
        User? user = _firebaseService!.user;
        if (user != null) {
          user.sendEmailVerification();
          Navigator.popAndPushNamed(context, "/details");
        }
      }
    } else {
      snackBarWithDismiss('Passwords doe not match');
    }
  }

  Widget formWidget() {
    return SizedBox(
      width: _deviceWidth,
      height: _deviceHeight * 0.55,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            textField(
              "Confirm Password",
              "Confirm your password",
              "Confirm Password",
              const Icon(Icons.security),
              true,
            ),
            registerButton(),
          ],
        ),
      ),
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

  Widget registerButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            snackBarWithDismiss("Checking data...");
            checkRegistration();
          }
        },
        child: const Text("Register"),
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
        (field == "Email")
            ? _email = val
            : (label == "Password")
                ? _pass = val
                : _confirmPass = val;
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
