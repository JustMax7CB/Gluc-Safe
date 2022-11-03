import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gluc_safe/Models/enums/genders.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:path/path.dart' as p;

final String USER_COLLECTION = 'users';
final String GLUCOSE_COLLECTION = 'glucose';
final String WEIGHT_COLLECTION = 'weight';
final String MEDICATION_COLLECTION = 'medication';
final String WORKOUT_COLLECTION = 'workout';

class FirebaseService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _database = FirebaseFirestore.instance;

  Map? currentUser;

  FirebaseService();

  get Auth => _auth;
  get DB => _database;
  get user => _auth.currentUser;

  Future<bool> registerUser(
      {required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      print("User registration failed");
      return false;
    }
  }

  Future<bool> loginUser(
      {required String email, required String password}) async {
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (_userCredential != null) {
        currentUser = await getUserData(uid: _userCredential.user!.uid);
        return true;
      }
      return false;
    } catch (e) {
      print("User login failed");
      return false;
    }
  }

  Future<bool> saveUserData({required GlucUser glucUser}) async {
    String userId = _auth.currentUser!.uid;
    String firstName = glucUser.firstName;
    String lastName = glucUser.lastName;
    DateTime birthDate = glucUser.birthDate;
    String gender = glucUser.gender;
    String mobileNum = glucUser.mobileNum;
    String contactName = glucUser.contactName;
    String contactMobile = glucUser.contactNum;

    try {
      await _database.collection(USER_COLLECTION).doc(userId).set(
        {
          'firstName': firstName,
          'lastName': lastName,
          'birthdate': birthDate,
          'gender': gender,
          'mobile': mobileNum,
          'contactName': contactName,
          'contactNumber': contactMobile,
        },
      );
      return true;
    } catch (e) {
      print("Failed to save user data");
      return false;
    }
  }

  Future<Map?> getUserData({required String uid}) async {
    try {
      DocumentSnapshot _doc =
          await _database.collection(USER_COLLECTION).doc(uid).get();
      return _doc.data() as Map;
    } catch (e) {
      print("User Document doesn't exist or failed to retrieve data");
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
