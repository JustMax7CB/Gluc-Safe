import 'package:age_calculator/age_calculator.dart';

class GlucUser {
  final String _uid;
  String? _fullName;
  String _email;
  String _pass;
  int? _age;
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
  get age => _age;
  get gender => _gender;
  get birthDate => _birthDate;

  //setter
  changePassword(String newPass) => _pass = newPass;
  setName(String name) => _fullName = name;
  setGender(String gender) => _gender = gender;
  setBirthdate(DateTime birth) {
    _birthDate = birth;
    calcAge();
  }

  setMobileNum(String mobile) => _mobileNum = mobile;
  calcAge() => _age = AgeCalculator.age(_birthDate!).years;

  dynamic toJson() => {
        'fullName': _fullName,
        'emailAddress': emailAddress,
        'mobile': mobile,
        'gender': gender,
        'birthDate': birthDate
      };

  @override
  String toString() {
    print("Email address: $_email\nPassword: $_pass");
    return 'GlucUser:\nuid: $_uid\nName: $_fullName\nAge: $_age\nBirthdate: $_birthDate\nMobile Number: $_mobileNum\nGender: $_gender';
  }
}
