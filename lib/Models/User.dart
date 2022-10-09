import 'package:age_calculator/age_calculator.dart';

class GlucUser {
  final String uid;
  String? _fullName;
  String email;
  String? pass;
  int? _age;
  DateTime? _birthDate;
  String? _gender;
  String? _mobileNum;

  //constructor
  GlucUser({required this.uid, required this.email, this.pass});

  //getters
  get fullName => _fullName;
  get firstName => _fullName!.split(' ')[0];
  get lastName => _fullName!.split(' ')[1];
  get emailAddress => email;
  get mobile => _mobileNum;
  get age => _age;
  get gender => _gender;
  get birthDate => _birthDate;

  //setter
  changePassword(String newPass) => pass = newPass;
  setName(String name) => _fullName = name;
  setGender(String gender) => _gender = gender;
  setBirthdate(DateTime birth) {
    _birthDate = birth;
    calcAge();
  }

  setMobileNum(String mobile) => _mobileNum = mobile;
  calcAge() => _age = AgeCalculator.age(_birthDate!).years;

  @override
  String toString() {
    print("Email address: $email\nPassword: $pass");
    return 'GlucUser:\nuid: $uid\nName: $_fullName\nAge: $_age\nBirthdate: $_birthDate\nMobile Number: $_mobileNum\nGender: $_gender';
  }
}
