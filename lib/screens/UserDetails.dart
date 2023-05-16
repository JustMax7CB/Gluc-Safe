import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/Models/enums/enumsExport.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/widgets/dropdown.dart';
import 'package:gluc_safe/widgets/glucsafeAppbar.dart';
import 'package:gluc_safe/widgets/textField.dart';
import 'package:gluc_safe/widgets/textStroke.dart';
import 'dart:developer' as dev;

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late double _deviceWidth;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  FirebaseService? _firebaseService;
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

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: glucSafeAppbar(context),
          body: Container(
            child: Form(
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
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 50,
                width: _deviceWidth * 0.4,
                child: InputFieldWidget(
                  hint: "details_page_user_first_name_label".tr(),
                  controller: _firstNameController,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 50,
                width: _deviceWidth * 0.4,
                child: InputFieldWidget(
                  hint: "details_page_user_last_name_label".tr(),
                  controller: _lastNameController,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 50,
                width: _deviceWidth * 0.4,
                child: DropDown(
                  optionList: Gender.values
                      .map((e) => e.toString().split(".")[1])
                      .toList(),
                  height: 40,
                  width: 30,
                  hint: "details_page_user_gender_label".tr(),
                  save: (value) => _genderController.text = value,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 50,
                width: _deviceWidth * 0.4,
                child: InputFieldWidget(
                  hint: "details_page_user_birthday_label".tr(),
                  controller: _dateController,
                  keyboard: TextInputType.datetime,
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            height: 50,
            width: _deviceWidth * 0.85,
            child: InputFieldWidget(
                hint: "details_page_user_phone_label".tr(),
                controller: _phoneController),
          ),
        ],
      ),
    );
  }

  Container contactInfoContainer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
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
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            height: 50,
            width: _deviceWidth * 0.85,
            child: InputFieldWidget(
                hint: "details_page_contact_name_label".tr(),
                controller: _contactNameController),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            height: 50,
            width: _deviceWidth * 0.85,
            child: InputFieldWidget(
                hint: "details_page_contact_phone_label".tr(),
                controller: _contactPhoneController),
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
    try {
      DateTime date = DateFormat("dd/MM/yyy").parse(_dateController.text);

      _formkey.currentState!.save();
      GlucUser glucUser = GlucUser(
        _firstNameController.text,
        _lastNameController.text,
        date,
        180,
        _genderController.text,
        _phoneController.text,
        _contactNameController.text,
        _contactPhoneController.text,
      );

      bool saveResult =
          await _firebaseService!.saveUserData(glucUser: glucUser);
      if (saveResult) {
        Navigator.popAndPushNamed(context, '/');
      }
    } catch (e) {
      dev.log("Saving user data failed with error: " + e.toString());
    }
  }
}
