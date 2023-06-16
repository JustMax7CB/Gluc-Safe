import 'dart:developer' as dev;
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/services/deviceQueries.dart';
import 'package:gluc_safe/widgets/customAppBar.dart';
import 'package:gluc_safe/widgets/textField.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/register_page_route.dart';
import '../widgets/glucsafeAppbar.dart';
import '../widgets/textStroke.dart';

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
            appBar: glucSafeAppbar(context, _deviceHeight!),
            resizeToAvoidBottomInset: false,
            body: loginContainer(),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (context.locale == const Locale('en')) {
              context.setLocale(const Locale('he'));
            } else {
              context.setLocale(const Locale('en'));
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 80, right: 15),
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                alignment: Alignment.topRight,
                "lib/assets/icons_svg/globe_lang.png",
                height: _deviceHeight! * 0.11,
              ),
            ),
          ),
        )
      ],
    );
  }

  Container loginContainer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 20),
      width: _deviceWidth,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "login_page_title".tr(),
                    style: TextStyle(
                      fontFamily: "DM_Sans",
                      fontSize: 60,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(59, 178, 67, 1),
                      shadows: <Shadow>[
                        const Shadow(
                          color: Color.fromRGBO(0, 0, 0, 0.6),
                          blurRadius: 0,
                          offset: Offset(0, 3),
                        ),
                        ...textStroke(
                          0.8,
                          const Color.fromRGBO(0, 0, 0, 0.6),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // Email Input
                    margin: const EdgeInsets.fromLTRB(35, 45, 35, 10),
                    child: InputFieldWidget(
                      hint: "input_email_hint".tr(),
                      label: "input_email_label".tr(),
                      controller: emailController,
                      leadingIcon: SvgPicture.asset(
                          "lib/assets/icons_svg/email_envelope.svg"),
                      validator: () {},
                    ),
                  ),
                  Container(
                    // Password input
                    margin: const EdgeInsets.symmetric(horizontal: 35),
                    child: InputFieldWidget(
                      hint: "input_password_hint".tr(),
                      label: "input_password_label".tr(),
                      obscure: obscurePassword,
                      controller: passwordController,
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
                      validator: () {},
                    ),
                  ),
                  Container(
                    // Forgot Password Text Button
                    margin: const EdgeInsets.fromLTRB(35, 0, 35, 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text(
                            "login_page_forgot_password".tr(),
                            style: const TextStyle(
                              fontFamily: "DM_Sans",
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () => resetPopup(context),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // Sign in Outline Button
                    decoration: BoxDecoration(
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        )
                      ],
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(45),
                      gradient: const RadialGradient(
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
                        fixedSize: const Size(220, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),
                      child: Text(
                        "login_page_signin_btn".tr(),
                        style: const TextStyle(
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
                  Container(
                    margin: const EdgeInsets.only(top: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("login_page_no_account".tr(),
                            style: const TextStyle(
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
                            style: const TextStyle(
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
        _firebaseService!.saveUserDeviceToken().then((value) {
          setState(() {
            isLoading = false;
          });
          Navigator.popAndPushNamed(context, "/");
        });
      }
      if (result is String) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        dev.log("Check: $result");
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
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.black38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          "login_page_forgot_confirm_btn".tr(),
          style: const TextStyle(
            fontFamily: "DM_Sans",
            color: Color.fromRGBO(59, 190, 65, 1),
          ),
        ),
        onPressed: () {
          try {
            if (_resetKey.currentState!.validate()) {
              _firebaseService?.resetPassword(email: resetEmail!);

              Navigator.pop(context);
              sleep(const Duration(milliseconds: 500));
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.success,
                  animType: AnimType.bottomSlide,
                  title: "login_page_forgot_popup_title".tr(),
                  desc: "login_page_forgot_popup_description".tr(),
                  autoHide: const Duration(
                    seconds: 3,
                  )).show();
            }
          } on FirebaseAuthException {
            snackBarWithDismiss("login_page_reset_failed".tr());
          }
        },
      ),
      btnCancel: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.black38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          "login_page_forgot_cancel_btn".tr(),
          style: const TextStyle(
            fontFamily: "DM_Sans",
            color: Color.fromRGBO(59, 190, 65, 1),
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Text(
            "login_page_forgot_popup_title".tr(),
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            height: _deviceHeight! * 0.06,
            child: Form(
              key: _resetKey,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  filled: true,
                  hintStyle: const TextStyle(fontSize: 13),
                  hintText: "input_email_label".tr(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
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
    ).show();
  }
}
