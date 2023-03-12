import 'dart:developer' as dev;
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
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
  final _resetKey = GlobalKey<FormState>();
  late String _email;
  late String _pass;
  String? resetEmail;
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
        leading: TextButton(
          onPressed: () {
            setState(() {
              if (context.locale == Locale('en'))
                context.setLocale(Locale('he'));
              else
                context.setLocale(Locale('en'));
            });
          },
          child: Text("misc_change_lang".tr()),
        ),
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
      label: Text(
        "login_page_google".tr(),
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
      snackBarWithDismiss(e.code);
    }
  }

  Widget formContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      width: _deviceWidth,
      height: _deviceHeight * 0.55,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              "login_page_title".tr(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: [
              textField(
                "input_email_label".tr(),
                "input_email_hint".tr(),
                "input_email_label".tr(),
                const Icon(Icons.email_outlined),
                false,
              ),
              SizedBox(height: 13),
              textField(
                "input_password_label".tr(),
                "input_password_hint".tr(),
                "input_password_label".tr(),
                const Icon(Icons.security),
                true,
              ),
              SizedBox(height: 8),
              resetBtn(),
            ],
          ),
          signInButton(),
          CircularContainer(),
          googleButton(),
        ],
      ),
    );
  }

  Widget resetBtn() {
    return SizedBox(
      height: 31,
      child: TextButton(
        onPressed: () => resetPopup(context),
        child: Text(
          "login_page_forgot_password".tr(),
          style: TextStyle(fontSize: 13, color: Colors.black),
        ),
      ),
    );
  }

  void resetPopup(BuildContext context) {
    AwesomeDialog(
      context: context,
      animType: AnimType.topSlide,
      dialogType: DialogType.noHeader,
      dismissOnTouchOutside: false,
      btnOk: OutlinedButton(
        child: Text("login_page_forgot_confirm_btn".tr()),
        onPressed: () {
          try {
            if (_resetKey.currentState!.validate()) {
              Future<bool>? result;
              if (_firebaseService?.resetPassword(email: resetEmail!) == false)
                throw Exception();
              Navigator.pop(context);
              sleep(Duration(milliseconds: 500));
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.success,
                  animType: AnimType.bottomSlide,
                  title: "login_page_forgot_popup_title".tr(),
                  desc: "login_page_forgot_popup_description".tr(),
                  autoHide: Duration(
                    seconds: 3,
                  )).show();
            }
          } catch (e) {
            snackBarWithDismiss("login_page_reset_failed".tr());
          }
        },
      ),
      btnCancel: OutlinedButton(
        child: Text("login_page_forgot_cancel_btn".tr()),
        onPressed: () => Navigator.pop(context),
      ),
      body: Container(
        child: Column(
          children: [
            Text(
              "login_page_forgot_popup_title".tr(),
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _resetKey,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: true,
                    hintStyle: const TextStyle(fontSize: 13),
                    hintText: "input_email_label".tr(),
                  ),
                  onChanged: (value) {
                    resetEmail = value;
                  },
                  validator: (val) {
                    Pattern pattern =
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    RegExp regExp = RegExp(pattern.toString());
                    if (val == null || val.isEmpty) {
                      return "login_page_email_empty".tr();
                    } else if (!regExp.hasMatch(val)) {
                      return "login_page_email_not_valid".tr();
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    ).show();
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
      child: Center(
        child: Text(
          "misc_or".tr(),
          style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }

  Widget signUpText() {
    return Column(
      children: [
        Text("login_page_no_account".tr()),
        TextButton(
          child: Text(
            "login_page_signup_btn".tr(),
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
    return ElevatedButton(
      onPressed: () {
        if (_formkey.currentState!.validate()) {
          snackBarWithDismiss("form_checking_data".tr());
          checkLogin();
        }
      },
      child: Text("login_page_signin_btn".tr()),
    );
  }

  snackBarWithDismiss(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "misc_snackbar_dismiss".tr(),
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
        (field == "Email" || field == "כתובת מייל")
            ? _email = val
            : _pass = val;
      },
      obscureText: obscure,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return "misc_field_empty".tr(args: [field]);
        }
        return null;
      },
    );
  }
}
