import 'package:age_calculator/age_calculator.dart';
import 'package:gluc_safe/Models/enums/genders.dart';

class GlucUser {
  late String _firstName;
  late String _lastName;
  late DateTime _birthDate;
  late int _height;
  late String _gender;
  late String _mobileNum;
  late String _contactName;
  late String _contactNum;

  //constructor
  GlucUser(String firstName, String lastName, DateTime birthDate, int height,
      String gender, String mobileNum, String contact, String contactNum) {
    _firstName = firstName;
    _lastName = lastName;
    _birthDate = birthDate;
    _height = height;
    _gender = gender;
    _mobileNum = mobileNum;
    _contactName = contact;
    _contactNum = contactNum;
  }

  get firstName => _firstName;
  get lastName => _lastName;
  get height => _height;
  get age => AgeCalculator.age(_birthDate);
  get gender => _gender;
  get birthDate => _birthDate;
  get mobileNum => _mobileNum;
  get contactName => _contactName;
  get contactNum => _contactNum;

  factory GlucUser.nullUser() =>
      GlucUser("", "", DateTime.now(), 0, "", "", "", "");
}
