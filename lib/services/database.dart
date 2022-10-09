import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

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
}
