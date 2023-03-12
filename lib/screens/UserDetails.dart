import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/Models/enums/enumsExport.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:gluc_safe/widgets/customAppBar.dart';
import 'package:intl/intl.dart';
import 'package:gluc_safe/widgets/details_card.dart';
import 'dart:developer' as dev;

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late double _deviceHeight, _deviceWidth;
  TextEditingController dateinput = TextEditingController();
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
  bool? _saveResult;

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
      appBar: customAppBar(context),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formkey,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.03,
                vertical: _deviceHeight * 0.02,
              ),
              child: Column(
                children: [
                  userBox(),
                  contactBox(),
                  saveButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget userBox() {
    return DetailsCard(
      title: "details_page_user_title".tr(),
      width: _deviceWidth,
      height: _deviceHeight,
      child: Column(
        children: [
          nameRow(),
          dividerWidget(),
          birthHeightRow(),
          dividerWidget(),
          genderDropDown(),
          dividerWidget(),
          phoneFormField(),
        ],
      ),
    );
  }

  Widget contactBox() {
    return DetailsCard(
      title: "details_page_contact_title".tr(),
      width: _deviceWidth,
      height: _deviceHeight,
      child: contactRow(),
    );
  }

  Widget phoneFormField() {
    return formField(
      "details_page_user_phone_label".tr(),
      const Icon(Icons.phone_android),
      "details_page_user_phone_hint".tr(),
    );
  }

  Widget nameRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: formField(
              "details_page_user_first_name_label".tr(),
              const Icon(Icons.person),
              "details_page_user_first_name_hint".tr(),
            ),
          ),
          Flexible(
            child: formField(
              "details_page_user_last_name_label".tr(),
              const Icon(Icons.person),
              "details_page_user_last_name_hint".tr(),
            ),
          ),
        ],
      ),
    );
  }

  Widget birthHeightRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Flexible(
            child: formField(
              "details_page_user_birthday_label".tr(),
              const Icon(Icons.calendar_today_outlined),
              "details_page_user_birthday_hint".tr(),
            ),
          ),
          Flexible(
            child: formField(
              "details_page_user_height_label".tr(),
              const Icon(Icons.height),
              "details_page_user_height_hint".tr(),
            ),
          ),
        ],
      ),
    );
  }

  Widget genderDropDown() {
    List genders =
        Gender.values.map((e) => e.toString().split(".")[1]).toList();
    List<DropdownMenuItem<String>> items = genders
        .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ))
        .toList();
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight * 0.02,
      ),
      width: _deviceWidth * 0.6,
      child: DropdownButtonFormField2(
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        isExpanded: true,
        hint: Text(
          "details_page_user_gender_hint".tr(),
          style: TextStyle(fontSize: 14),
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
        buttonHeight: _deviceHeight * 0.05,
        buttonPadding: const EdgeInsets.only(left: 20, right: 10),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        items: items,
        validator: (value) {
          if (value == null) {
            return "details_page_user_gender_error".tr();
          }
          return null;
        },
        onChanged: (value) {
          userData['gender'] = value.toString();
        },
        onSaved: (value) {
          userData['gender'] = value.toString();
        },
      ),
    );
  }

  Widget formField(String label, Icon icon, String hint) {
    return TextFormField(
      keyboardType: (label == "details_page_user_phone_label".tr() ||
              label == "details_page_user_height_label".tr() ||
              label == "details_page_contact_phone_label".tr())
          ? TextInputType.number
          : null,
      readOnly: (label == "details_page_user_birthday_label".tr()),
      controller:
          (label == "details_page_user_birthday_label".tr()) ? dateinput : null,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        filled: false,
        icon: icon,
        hintStyle: const TextStyle(fontSize: 13),
        hintText: hint,
        labelText: label,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "misc_label_empty".tr();
        }
        return null;
      },
      onTap: (label == "details_page_user_birthday_label".tr())
          ? calendarShow
          : null,
      onSaved: (newValue) {
        saveValue(label, newValue!);
      },
    );
  }

  saveValue(String label, String value) {
    switch (label) {
      case "First Name":
      case "שם פרטי":
        userData['firstName'] = value;
        break;
      case "Last Name":
      case "שם משפחה":
        userData['lastName'] = value;
        break;
      case "Height":
      case "גובה":
        userData['height'] = int.parse(value);
        break;
      case "Phone Number":
      case "מס' טלפון":
        userData['mobileNum'] = value;
        break;
      case "Contact Name":
      case "שם איש קשר":
        userData['contactName'] = value;
        break;
      case "Contact Phone Number":
      case "מס' טלפון של איש קשר":
        userData['contactNumber'] = value;
        break;
    }
  }

  Widget contactRow() {
    return Column(
      children: [
        formField(
          "details_page_contact_name_label".tr(),
          const Icon(Icons.emergency_sharp),
          "details_page_contact_name_hint".tr(),
        ),
        dividerWidget(),
        formField(
          "details_page_contact_phone_label".tr(),
          const Icon(Icons.phone_android_sharp),
          "details_page_contact_phone_hint".tr(),
        ),
      ],
    );
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: _deviceHeight * 0.05),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        splashColor: const Color.fromARGB(255, 152, 113, 20),
        onTap: () async {
          try {
            _formkey.currentState!.save();
            GlucUser glucUser = GlucUser(
              userData['firstName'],
              userData['lastName'],
              userData['birthDate'],
              userData['height'],
              userData['gender'],
              userData['mobileNum'],
              userData['contactName'],
              userData['contactNumber'],
            );
            _saveResult =
                await _firebaseService!.saveUserData(glucUser: glucUser);
          } catch (e) {
            print("Some error occured while saving user data");
            print(e);
          } finally {
            if (_saveResult != null && _saveResult == true) {
              Navigator.popAndPushNamed(context, '/');
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(243, 220, 149, 62),
            borderRadius: BorderRadius.circular(18),
          ),
          height: _deviceHeight * 0.07,
          width: _deviceWidth * 0.5,
          child: Center(
            child: Text(
              "misc_save".tr(),
              style: TextStyle(
                fontSize: 24,
                fontFamily: "BebasNeue",
                letterSpacing: 1.3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dividerWidget() {
    return Divider(
      height: 3,
      thickness: 1,
      indent: 35,
      endIndent: 35,
      color: Colors.grey[400],
    );
  }

  void calendarShow() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(
            1950), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2050));

    if (pickedDate != null) {
      userData['birthDate'] = pickedDate;
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      dev.log(
          formattedDate); //formatted date output using intl package =>  16/03/2021
      //you can implement different kind of Date Format here according to your requirement

      setState(() {
        dateinput.text = formattedDate; //set output date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }

  AppBar customAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 120,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      flexibleSpace: ClipPath(
        clipper: CustomAppBar(),
        child: Container(
          height: 250,
          width: MediaQuery.of(context).size.width,
          color: Colors.amber[800],
          child: Center(
            child: Text(
              "details_page_title".tr(),
              style: TextStyle(
                fontSize: 32,
                fontFamily: "BebasNeue",
                letterSpacing: 1.5,
                color: Color.fromARGB(255, 19, 16, 13),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
