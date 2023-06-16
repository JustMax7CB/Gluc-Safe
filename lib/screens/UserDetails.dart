import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/Models/enums/enums_export.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:gluc_safe/screens/login_page.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/services/deviceQueries.dart';
import 'package:gluc_safe/widgets/dropdown.dart';
import 'package:gluc_safe/widgets/glucsafeAppbar.dart';
import 'package:gluc_safe/widgets/infoDialog.dart';
import 'package:gluc_safe/widgets/textField.dart';
import 'package:gluc_safe/widgets/textStroke.dart';
import 'dart:developer' as dev;

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  bool isLoading = false;
  Map userData = {
    "firstName": null,
    "lastName": null,
    "birthDate": DateTime,
    "height": num,
    "gender": null,
    "mobileNum": null,
    "contactName": null,
    "contactNumber": null,
  };

  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  double? _deviceWidth, _deviceHeight;
  FirebaseService? _firebaseService;
  final TextEditingController _firstNameController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

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
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: glucSafeAppbar(context, _deviceHeight!),
          body: Container(
            child: isLoading
                ? Center(child: const CircularProgressIndicator())
                : Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        userInfoContainer(),
                        contactInfoContainer(),
                        saveButton(),
                      ],
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
            padding: const EdgeInsets.only(top: 80, right: 15),
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

  Container userInfoContainer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, bottom: 5),
            child: Row(
              children: [
                Text(
                  "details_page_title".tr(),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    fontFamily: "DM_Sans",
                    color: Color.fromRGBO(86, 180, 98, 1),
                    shadows: <Shadow>[
                      Shadow(
                        blurRadius: 0,
                        offset: Offset(0, 2),
                      )
                    ]..addAll(textStroke(0.5, Colors.black)),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: _deviceHeight! * 0.005),
                width: _deviceWidth! * 0.4,
                child: InputFieldWidget(
                  hint: "details_page_user_first_name_label".tr(),
                  controller: _firstNameController,
                  keyboard: TextInputType.text,
                  validator: (firstName) {
                    if (!RegExp(r'^[a-zA-Zא-ת]+$').hasMatch(firstName)) {
                      return 'Invalid first name';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: _deviceHeight! * 0.005),
                width: _deviceWidth! * 0.4,
                child: InputFieldWidget(
                  hint: "details_page_user_last_name_label".tr(),
                  controller: _lastNameController,
                  keyboard: TextInputType.text,
                  validator: (lastName) {
                    if (!RegExp(r'^[a-zA-Zא-ת]+$').hasMatch(lastName)) {
                      return 'Invalid first name';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.only(top: _deviceHeight! * 0.015),
                width: _deviceWidth! * 0.4,
                child: DropDown(
                  optionList: gendersToString(context.locale),
                  height: _deviceHeight! * 0.085,
                  width: 30,
                  hint: "details_page_user_gender_label".tr(),
                  save: (value) => _genderController.text = value,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: _deviceHeight! * 0.005),
                width: _deviceWidth! * 0.4,
                child: InputFieldWidget(
                  hint: "details_page_user_birthday_label".tr(),
                  controller: _dateController,
                  keyboard: TextInputType.datetime,
                  validator: (String birthdate) {
                    if (birthdate.isEmpty) {
                      return 'Should not be empty';
                    }
                    return null;
                  },
                  read: true,
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      dateFormat: 'dd/MMMM/yyyy',
                      initialDateTime: DateTime.now(),
                      minDateTime: DateTime(1900),
                      maxDateTime: DateTime.now(),
                      onConfirm: (dateTime, selectedIndex) {
                        String formattedDateTime =
                            DateFormat('dd/MM/yyyy').format(dateTime);
                        dev.log("Formatted Date Time: $formattedDateTime");
                        setState(() {
                          _dateController.text = formattedDateTime;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: _deviceHeight! * 0.05),
                width: _deviceWidth! * 0.4,
                child: InputFieldWidget(
                  hint: "details_page_user_phone_label".tr(),
                  controller: _phoneController,
                  keyboard: TextInputType.phone,
                  validator: (phoneNum) {
                    if (!RegExp(r'^0([23489]|[57]\d)\-?\d{7}$')
                        .hasMatch(phoneNum)) {
                      return 'Invalid phone number';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: _deviceHeight! * 0.05),
                width: _deviceWidth! * 0.4,
                child: InputFieldWidget(
                  hint: "details_page_user_height_label".tr(),
                  controller: _heightController,
                  keyboard: TextInputType.number,
                  validator: (String height) {
                    if (height.length > 3 || height.length < 2) {
                      return 'Invalid height in (cm)';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container contactInfoContainer() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, bottom: 5),
            child: Row(
              children: [
                Text(
                  "details_page_contact_title".tr(),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    fontFamily: "DM_Sans",
                    color: Color.fromRGBO(86, 180, 98, 1),
                    shadows: <Shadow>[
                      Shadow(
                        blurRadius: 0,
                        offset: Offset(0, 2),
                      )
                    ]..addAll(textStroke(0.5, Colors.black)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: _deviceHeight! * 0.005),
            width: _deviceWidth! * 0.85,
            child: InputFieldWidget(
              height: _deviceHeight! * 0.085,
              hint: "details_page_contact_name_label".tr(),
              controller: _contactNameController,
              keyboard: TextInputType.text,
              validator: (name) {
                if (!RegExp(r'^[a-zA-Zא-ת]+$').hasMatch(name)) {
                  return 'Invalid contect name';
                }
                return null;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: _deviceHeight! * 0.015),
            width: _deviceWidth! * 0.85,
            child: InputFieldWidget(
              height: _deviceHeight! * 0.085,
              hint: "details_page_contact_phone_label".tr(),
              controller: _contactPhoneController,
              keyboard: TextInputType.phone,
              validator: (phoneNum) {
                if (!RegExp(r'^0([23489]|[57]\d)\-?\d{7}$')
                    .hasMatch(phoneNum)) {
                  return 'Invalid phone number';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Container saveButton() {
    return Container(
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
        onPressed: saveDetails,
        style: OutlinedButton.styleFrom(
          fixedSize: Size(220, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45),
          ),
        ),
        child: Text(
          "Save".tr(),
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
    );
  }

  saveDetails() async {
    _formkey.currentState!.validate();
    setState(() {
      isLoading = true;
    });
    try {
      DateTime date = DateFormat("dd/MM/yyy").parse(_dateController.text);

      _formkey.currentState!.save();
      GlucUser glucUser = GlucUser(
        _firstNameController.text,
        _lastNameController.text,
        date,
        int.parse(_heightController.text),
        _genderController.text,
        _phoneController.text,
        _contactNameController.text,
        _contactPhoneController.text,
      );

      bool saveResult =
          await _firebaseService!.saveUserData(glucUser: glucUser);
      if (saveResult) {
        setState(() {
          isLoading = false;
        });
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ));
        });
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return InfoDialog(
                title: "details_page_info_dialog_title".tr(),
                details: "details_page_info_dialog_description".tr(),
                height: _deviceWidth! * 0.2,
                width: _deviceWidth! * 0.9);
          },
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      dev.log("Saving user data failed with error: " + e.toString());
    }
  }
}
