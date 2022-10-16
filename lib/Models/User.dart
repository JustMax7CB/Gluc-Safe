import 'package:age_calculator/age_calculator.dart';
import 'package:gluc_safe/Models/user.dart';

class GlucUser {
  final String _uid;
  String? _fullName;
  String _email;
  String _pass;
  DateTime? _birthDate;
  String? _gender;
  String? _mobileNum;

  //constructor
  GlucUser(
      {required String uid,
      required String email,
      required String pass,
      String? name,
      DateTime? birth,
      String? gender,
      String? mobile})
      : _uid = uid,
        _email = email,
        _pass = pass,
        _fullName = name,
        _birthDate = birth,
        _gender = gender,
        _mobileNum = mobile;

  //getters
  get uid => _uid;
  get pass => _pass;
  get fullName => _fullName;
  get firstName => _fullName!.split(' ')[0];
  get lastName => _fullName!.split(' ')[1];
  get emailAddress => _email;
  get mobile => _mobileNum;
  get age => calcAge();
  get gender => _gender;
  get birthDate => _birthDate;

  //setter
  changePassword(String newPass) => _pass = newPass;
  setName(String name) => _fullName = name;
  setGender(String gender) => _gender = gender;
  setBirthdate(DateTime birth) => _birthDate = birth;

  setMobileNum(String mobile) => _mobileNum = mobile;
  calcAge() => AgeCalculator.age(_birthDate!).years;

  factory GlucUser.fromMap(Map glucUser) {
    return GlucUser(
        uid: glucUser['uid'], email: glucUser['email'], pass: glucUser['pass']);
  }

  Map<String, dynamic> toMap() => {
        'uid': _uid,
        'pass': _pass,
        'fullName': _fullName,
        'emailAddress': emailAddress,
        'mobile': mobile,
        'gender': gender,
        'birthDate': birthDate
      };

  @override
  String toString() {
    print("Email address: $_email\nPassword: $_pass");
    return 'GlucUser:\nuid: $_uid\nName: $_fullName\nAge: ${calcAge()}\nBirthdate: $_birthDate\nMobile Number: $_mobileNum\nGender: $_gender';
  }
}
