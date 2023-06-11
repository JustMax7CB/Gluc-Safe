import 'dart:developer' as dev;

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/services/deviceQueries.dart';
import 'package:gluc_safe/widgets/infoDialog.dart';

import '../widgets/glucsafeAppbar.dart';
import '../widgets/textField.dart';
import '../widgets/textStroke.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double? _deviceWidth, _deviceHeight;
  final _formkey = GlobalKey<FormState>();
  final _emailInputKey = GlobalKey<FormFieldState>();
  final _passwordInputKey = GlobalKey<FormFieldState>();
  final _confirmPasswordInputKey = GlobalKey<FormFieldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  FirebaseService? _firebaseService;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    if (_deviceWidth == null || _deviceHeight == null) {
      _deviceWidth = getDeviceWidth(context);
      _deviceHeight = getDeviceHeight(context);
    }

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
            body: isLoading
                ? Center(child: const CircularProgressIndicator())
                : Container(
                    margin: EdgeInsets.only(bottom: 10, top: 20),
                    width: _deviceWidth,
                    child: Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "login_page_signup_btn".tr(),
                            style: TextStyle(
                              fontFamily: "DM_Sans",
                              fontSize: 60,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(59, 178, 67, 1),
                              shadows: <Shadow>[
                                Shadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.6),
                                  blurRadius: 0,
                                  offset: Offset(0, 3),
                                ),
                              ]..addAll(
                                  textStroke(
                                    0.8,
                                    Color.fromRGBO(0, 0, 0, 0.6),
                                  ),
                                ),
                            ),
                          ),
                          Container(
                            // Email Input
                            margin: EdgeInsets.fromLTRB(35, 45, 35, 10),
                            child: InputFieldWidget(
                              fieldKey: _emailInputKey,
                              hint: "input_email_hint".tr(),
                              label: "input_email_label".tr(),
                              controller: _emailController,
                              leadingIcon: SvgPicture.asset(
                                "lib/assets/icons_svg/email_envelope.svg",
                              ),
                              validator: (value) {
                                // if (!checkEmailFormat(value)) {
                                //   return "";
                                // }
                                // return null;
                              },
                            ),
                          ),
                          Container(
                            // Password input
                            margin: EdgeInsets.fromLTRB(35, 0, 35, 10),
                            child: InputFieldWidget(
                              fieldKey: _passwordInputKey,
                              hint: "input_password_hint".tr(),
                              label: "input_password_label".tr(),
                              obscure: obscurePassword,
                              controller: _passwordController,
                              leadingIcon: SvgPicture.asset(
                                  "lib/assets/icons_svg/password_lock.svg"),
                              actionIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                                child: SvgPicture.asset(
                                    "lib/assets/icons_svg/password_view_enabled.svg",
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.scaleDown),
                              ),
                              validator: (value) {
                                // if (!checkPasswordLength(value)) {
                                //   return "";
                                // }
                                // return null;
                              },
                            ),
                          ),
                          Container(
                            // Confirm Password input
                            margin: EdgeInsets.fromLTRB(35, 0, 35, 35),
                            child: InputFieldWidget(
                              fieldKey: _confirmPasswordInputKey,
                              hint: "input_confirm_password_hint".tr(),
                              label: "input_confirm_password_label".tr(),
                              obscure: obscureConfirmPassword,
                              controller: _confirmPasswordController,
                              leadingIcon: SvgPicture.asset(
                                  "lib/assets/icons_svg/password_lock.svg"),
                              actionIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscureConfirmPassword =
                                        !obscureConfirmPassword;
                                  });
                                },
                                child: SvgPicture.asset(
                                    "lib/assets/icons_svg/password_view_enabled.svg",
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.scaleDown),
                              ),
                              validator: (value) {
                                // if (checkPasswordsMatch(value) == 0) {
                                //   return "";
                                // }
                                // return null;
                              },
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
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                if (!_emailInputKey.currentState!.validate()) {
                                  dev.log(
                                      ' Email Validation : ${_emailInputKey.currentState!.validate().toString()}');
                                  snackBarWithDismiss("Email invalid format");
                                } else if (!_passwordInputKey.currentState!
                                    .validate()) {
                                  dev.log(
                                      ' Password Validation : ${_passwordInputKey.currentState!.validate().toString()}');
                                  snackBarWithDismiss(
                                      "Password should be at least 6 characters");
                                } else if (!_confirmPasswordInputKey
                                    .currentState!
                                    .validate()) {
                                  dev.log(
                                      ' Confirm Password Validation : ${_confirmPasswordInputKey.currentState!.validate().toString()}');
                                  snackBarWithDismiss(
                                      "The passwords does not match");
                                }

                                await checkRegistration().then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (value) {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        Future.delayed(Duration(seconds: 3),
                                            () {
                                          Navigator.popUntil(context,
                                              ModalRoute.withName('/'));
                                          Navigator.popAndPushNamed(
                                              context, '/details');
                                        });
                                        return InfoDialog(
                                          title:
                                              "register_info_dialog_title".tr(),
                                          details:
                                              "register_info_dialog_description"
                                                  .tr(),
                                          height: _deviceHeight! * 0.2,
                                          width: _deviceWidth! * 0.9,
                                        );
                                      },
                                    );
                                  }
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                fixedSize: Size(220, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(45),
                                ),
                              ),
                              child: Text(
                                "login_page_signup_btn".tr(),
                                style: TextStyle(
                                    fontFamily: "DM_Sans",
                                    fontSize: 30,
                                    color: Colors.white,
                                    shadows: <Shadow>[
                                      Shadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.25),
                                        blurRadius: 2,
                                        offset: Offset(2, 4),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: _deviceHeight! * 0.05),
                            child: Text(
                              "register_page_password_length_hint".tr(),
                              style: TextStyle(
                                  fontSize: 13, fontFamily: "DM_Sans"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
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
            padding: context.locale == Locale('en')
                ? const EdgeInsets.only(top: 75, right: 15)
                : const EdgeInsets.only(top: 75, left: 15),
            child: Align(
              alignment: context.locale == Locale('en')
                  ? Alignment.topRight
                  : Alignment.topLeft,
              child: Container(
                child: Image.asset(
                  alignment: context.locale == Locale('en')
                      ? Alignment.topRight
                      : Alignment.topLeft,
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

  bool checkEmailFormat(String emailString) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailString);
  }

  bool checkPasswordLength(String password) {
    return password.length >= 6;
  }

  int checkPasswordsMatch(String confirmPassword) {
    return _passwordController.text.compareTo(confirmPassword);
  }

  Future<bool> checkRegistration() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        bool result = await _firebaseService!.registerUser(
            email: _emailController.text, password: _passwordController.text);
        return result;
      } on FirebaseAuthException catch (e) {
        snackBarWithDismiss("register_page_invalid_data".tr());
        return false;
      }
    } else {
      snackBarWithDismiss("register_page_passwords_no_match".tr());
      return false;
    }
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
}
