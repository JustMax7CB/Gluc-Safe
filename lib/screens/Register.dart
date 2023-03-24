import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:gluc_safe/services/database.dart';

import '../widgets/customAppBar.dart';
import '../widgets/glucsafeAppbar.dart';
import '../widgets/textField.dart';
import '../widgets/textStroke.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHeight, _deviceWidth;
  final _formkey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  FirebaseService? _firebaseService;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: glucSafeAppbar(context),
          body: Container(
            margin: EdgeInsets.only(bottom: 10, top: 20),
            width: _deviceWidth,
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
                    hint: "input_email_hint".tr(),
                    label: "input_email_label".tr(),
                    controller: _emailController,
                    leadingIcon: SvgPicture.asset(
                        "lib/assets/icons_svg/email_envelope.svg"),
                    onChanged: () {},
                    validator: () {},
                  ),
                ),
                Container(
                  // Password input
                  margin: EdgeInsets.fromLTRB(35, 0, 35, 10),
                  child: InputFieldWidget(
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
                    onChanged: () {},
                    validator: () {},
                  ),
                ),
                Container(
                  // Confirm Password input
                  margin: EdgeInsets.fromLTRB(35, 0, 35, 35),
                  child: InputFieldWidget(
                    hint: "input_confirm_password_hint".tr(),
                    label: "input_confirm_password_label".tr(),
                    obscure: obscurePassword,
                    controller: _confirmPasswordController,
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
                    onChanged: () {},
                    validator: () {},
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
                    onPressed: checkRegistration,
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
              ],
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
            padding: const EdgeInsets.only(top: 75, right: 15),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                child: Image.asset(
                  "lib/assets/icons_svg/globe_lang.png",
                  height: 45,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future checkRegistration() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        await _firebaseService!.registerUser(
            email: _emailController.text, password: _passwordController.text);
      } on FirebaseAuthException catch (e) {
        snackBarWithDismiss("register_page_invalid_data".tr());
      } finally {
        User? user = _firebaseService!.user;
        if (user != null) {
          user.sendEmailVerification();
          Navigator.popAndPushNamed(context, "/details");
        }
      }
    } else {
      snackBarWithDismiss("register_page_passwords_no_match".tr());
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
