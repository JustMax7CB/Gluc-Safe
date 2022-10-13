import 'package:flutter/material.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:gluc_safe/assets/customAppBar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:intl/intl.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late double deviceHeight, deviceWidth;
  TextEditingController dateinput = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  late String _name;
  late DateTime _birthDate;
  late String _gender;
  late String _mobileNum;
  var glucUser;

  @override
  Widget build(BuildContext context) {
    glucUser = ModalRoute.of(context)!.settings.arguments as GlucUser;
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: customAppBar(context),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                formField("name", const Icon(Icons.person_pin), "Full Name"),
                dividerWidget(),
                formField(
                    "birth", const Icon(Icons.calendar_today), "Birthdate"),
                dividerWidget(),
                formField("mobile", const Icon(Icons.phone_android_rounded),
                    "Mobile Number"),
                dividerWidget(),
                genderDropDown(),
                saveButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget genderDropDown() {
    List genders = ["Male", "Female", "Transgender", "Nonbinary", "None"];
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
    return Padding(
      padding: EdgeInsets.fromLTRB(
          deviceWidth * 0.2, deviceHeight * 0.05, deviceWidth * 0.2, 0),
      child: DropdownButtonFormField2(
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        isExpanded: true,
        hint: const Text(
          'Select Your Gender',
          style: TextStyle(fontSize: 14),
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
        buttonHeight: 60,
        buttonPadding: const EdgeInsets.only(left: 20, right: 10),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        items: items,
        validator: (value) {
          if (value == null) {
            return 'Please select gender.';
          }
          return null;
        },
        onChanged: (value) {
          _gender = value.toString();
        },
        onSaved: (value) {
          _gender = value.toString();
        },
      ),
    );
  }

  Future saveUserCollection(GlucUser gluc) async {
    await DatabaseService(uid: gluc.uid).updateUserMobile(
        gluc.fullName,
        gluc.emailAddress,
        gluc.pass!,
        gluc.gender,
        gluc.mobile,
        gluc.age,
        gluc.birthDate);
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: deviceHeight * 0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        splashColor: const Color.fromARGB(255, 152, 113, 20),
        onTap: () {
          glucUser.setBirthdate(_birthDate);
          glucUser.setGender(_gender);
          glucUser.setName(_name);
          glucUser.setMobileNum(_mobileNum);
          saveUserCollection(glucUser);
          Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(243, 220, 149, 62),
            borderRadius: BorderRadius.circular(18),
          ),
          height: deviceHeight * 0.07,
          width: deviceWidth * 0.5,
          child: const Center(
            child: Text(
              "Save",
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
    return const Divider(
      height: 5,
      thickness: 1,
      color: Colors.grey,
    );
  }

  Widget formField(String field, Icon icon, String hint) {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(deviceWidth * 0.05, 60, deviceWidth * 0.05, 0),
      child: TextFormField(
        readOnly: (field == "birth"),
        controller: (field == "birth") ? dateinput : null,
        keyboardType:
            (field == "mobile") ? TextInputType.number : TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          icon: icon,
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 18),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onTap: (field == "birth") ? calendarShow : null,
        onChanged: (val) {
          switch (field) {
            case "name":
              _name = val;
              break;
            case "mobile":
              _mobileNum = val;
              break;
          }
        },
      ),
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
      _birthDate = pickedDate;
      print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      print(
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
          child: const Center(
            child: Text(
              "User Details",
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
