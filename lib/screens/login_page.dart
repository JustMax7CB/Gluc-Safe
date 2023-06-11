import 'dart:developer' as dev;
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/services/deviceQueries.dart';

import 'package:gluc_safe/widgets/textField.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../routes/registerPageRoute.dart';
import '../widgets/glucsafeAppbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double? _deviceWidth, _deviceHeight;
  final _formkey = GlobalKey<FormState>();
  final _resetKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  String? resetEmail;
  FirebaseService? _firebaseService;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  void dispose() {
    isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_deviceWidth == null || _deviceHeight == null) {
      _deviceWidth = getDeviceWidth(context);
      _deviceHeight = getDeviceHeight(context);
    }

    dev.log("Height: ${_deviceHeight}, Width: ${_deviceWidth}");

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: glucSafeAppbar(context, _deviceHeight!),
            body: loginContainer(),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (context.locale == Locale('en'))
              context.setLocale(Locale('he'));
            else
              context.setLocale(Locale('en'));
          },
          child: Padding(
            padding: EdgeInsets.only(
                top: _deviceHeight! * 0.08, right: _deviceWidth! * 0.04),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                child: Image.asset(
                  alignment: Alignment.topRight,
                  "lib/assets/icons_svg/globe_lang.png",
                  height: _deviceHeight! * 0.11,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Container loginContainer() {
    return Container(
      margin: EdgeInsets.only(top: _deviceHeight! * 0.005),
      width: _deviceWidth,
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "login_page_title".tr(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Container(
                    // Email Input
                    margin: EdgeInsets.fromLTRB(
                        _deviceWidth! * 0.09,
                        _deviceHeight! * 0.05,
                        _deviceWidth! * 0.09,
                        _deviceHeight! * 0.015),
                    child: InputFieldWidget(
                      hint: "input_email_hint".tr(),
                      label: "input_email_label".tr(),
                      controller: emailController,
                      leadingIcon: SvgPicture.asset(
                          width: _deviceWidth! * 0.07,
                          "lib/assets/icons_svg/email_envelope.svg"),
                      validator: () {},
                    ),
                  ),
                  Container(
                    // Password input
                    margin:
                        EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.09),
                    child: InputFieldWidget(
                      hint: "input_password_hint".tr(),
                      label: "input_password_label".tr(),
                      obscure: obscurePassword,
                      controller: passwordController,
                      leadingIcon: SvgPicture.asset(
                          width: _deviceWidth! * 0.07,
                          "lib/assets/icons_svg/password_lock.svg"),
                      actionIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        child: SvgPicture.asset(
                          "lib/assets/icons_svg/password_view_enabled.svg",
                          height: _deviceHeight! * 0.037,
                          width: _deviceHeight! * 0.037,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      validator: () {},
                    ),
                  ),
                  Container(
                    // Forgot Password Text Button
                    margin: EdgeInsets.fromLTRB(_deviceWidth! * 0.085, 0,
                        _deviceWidth! * 0.085, _deviceHeight! * 0.044),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text(
                            "login_page_forgot_password".tr(),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          onPressed: () => resetPopup(context),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // Sign in Outline Button
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        )
                      ],
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(45),
                      gradient: RadialGradient(
                        radius: 13,
                        focal: Alignment.topRight,
                        colors: <Color>[
                          Color.fromRGBO(23, 154, 40, 1),
                          Color.fromRGBO(86, 180, 98, 0)
                        ],
                      ),
                    ),
                    child: OutlinedButton(
                      onPressed: checkLogin,
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size(220, 50),
                      ),
                      child: Text(
                        "login_page_signin_btn".tr(),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: _deviceHeight! * 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("login_page_no_account".tr(),
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "DM_Sans",
                                shadows: <Shadow>[
                                  Shadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                    blurRadius: 1,
                                    offset: Offset(0, 2),
                                  )
                                ])),
                        TextButton(
                          child: Text(
                            "login_page_signup_btn".tr(),
                            style: TextStyle(
                              fontFamily: "DM_Sans",
                              fontSize: 20,
                              color: Color.fromRGBO(48, 185, 67, 1),
                              shadows: <Shadow>[
                                Shadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  blurRadius: 1,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                          ),
                          onPressed: () =>
                              Navigator.of(context).push(registerPageRoute()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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

  Future<void> checkLogin() async {
    try {
      setState(() {
        isLoading = true;
      });
      snackBarWithDismiss("login_page_signin_checking".tr());
      var result = await _firebaseService!.loginUser(
          email: emailController.text, password: passwordController.text);
      if (result is UserCredential) {
        _firebaseService!.saveUserDeviceToken();
      }
      if (result is String) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        dev.log("Check: " + result);
        setState(() {
          isLoading = false;
        });
        throw FirebaseAuthException(code: result);
      }
    } on FirebaseAuthException catch (e) {
      dev.log("error is: $e");
      snackBarWithDismiss(e.code);
    }
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
              _firebaseService?.resetPassword(email: resetEmail!);

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
                ),
              ).show();
            }
          } on FirebaseAuthException {
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
              margin: EdgeInsets.symmetric(
                horizontal: _deviceWidth! * 0.05,
                vertical: _deviceHeight! * 0.02,
              ),
              child: Form(
                key: _resetKey,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: _deviceWidth! * 0.03),
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
}
