import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  static final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  static final CollectionReference usersGlucose =
      FirebaseFirestore.instance.collection('usersGlucose');

  Future updateUserMobile(String fullName, String email, String pass,
      String gender, String mobile, int age, DateTime birth) async {
    return await users.doc(uid).set({
      "fullName": fullName,
      'email': email,
      'pass': pass,
      'gender': gender,
      'age': age,
      'birthdate': birth,
      'mobileNum': mobile
    });
  }

  Future updateUserGlucose(double value, String fullName) async {
    return await usersGlucose
        .doc(uid)
        .collection(fullName)
        .doc()
        .set({'Time': DateTime.now(), "Value": value});
  }
}
