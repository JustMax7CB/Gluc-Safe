import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gluc_safe/Models/enums/genders.dart';
import 'package:gluc_safe/Models/glucose.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:path/path.dart' as p;
import 'dart:developer' as dev;

final String USER_COLLECTION = 'users';
final String GLUCOSE_COLLECTION = 'glucose';
final String WEIGHT_COLLECTION = 'weight';
final String MEDICATION_COLLECTION = 'medication';
final String WORKOUT_COLLECTION = 'workout';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Map? currentUser;

  FirebaseService();

  get Auth => _auth;
  get DB => _database;
  get user => _auth.currentUser;

  Future<bool> registerUser(
      {required String email, required String password}) async {
    // gets email and password as string
    // the function will try to register the user to the firebase database
    // and will return true if successful otherwise return false
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      dev.log(e.toString());
      dev.log("User registration failed");
      return false;
    }
  }

  Future<bool> loginUser(
      {required String email, required String password}) async {
    // gets email and password as string
    // the function will try to sign in the user using the email and password provided
    // by checking the the firebase authentication database
    // and will return true if successful otherwise return false
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (_userCredential != null) {
        currentUser = await getUserData();
        return true;
      }
      return false;
    } catch (e) {
      print("User login failed");
      return false;
    }
  }

  Future<bool> saveUserData({required GlucUser glucUser}) async {
    // gets an instance of GlucUser
    // the function will try to save the user details to the firebase database
    // and will return true if successful otherwise return false
    String userId = user!.uid;
    String firstName = glucUser.firstName;
    String lastName = glucUser.lastName;
    DateTime birthDate = glucUser.birthDate;
    int height = glucUser.height;
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
          'height': height,
          'gender': gender,
          'mobile': mobileNum,
          'contactName': contactName,
          'contactNumber': contactMobile,
        },
      );
      await _database
          .collection(GLUCOSE_COLLECTION)
          .doc(userId)
          .set({'valuesList': []});
      return true;
    } catch (e) {
      print("Failed to save user data");
      return false;
    }
  }

  Future<Map?> getUserData() async {
    // gets user id as a string
    // the function will try to get the user data from the firebase database
    // and will return a map of the user data if successful otherwise return null
    try {
      String? userID = user!.uid;
      DocumentSnapshot _doc =
          await _database.collection(USER_COLLECTION).doc(userID).get();
      return _doc.data() as Map;
    } catch (e) {
      print("User Document doesn't exist or failed to retrieve data");
      return null;
    }
  }

  Future<void> logout() async {
    // the function will try to log out the user
    // if successful user will be logged out otherwise exception will be thrown
    try {
      await _auth.signOut();
    } catch (e) {
      print("Logout Failed");
    }
  }

  Future<bool> saveGlucoseData(Glucose glucoseData) async {
    // gets an instance of Glucose
    // the function will try to save the glucose data to the firebase database
    // will return true if successful otherwise return false
    List valuesListFromDB = [];
    String userId = user!.uid;
    DateTime dataDate = glucoseData.date;
    int dataGlucose = glucoseData.glucoseValue;
    int? dataCarbs = glucoseData.carbs;
    String? dataMeal = glucoseData.meal.toString().split('.')[1];
    String? dataNotes = glucoseData.notes;
    final glucReading = {
      "Date": dataDate,
      "Glucose": dataGlucose,
      "Carbs": dataCarbs,
      "Meal": dataMeal,
      "Notes": dataNotes,
    };
    try {
      var document = await _database.collection('glucose').doc(userId).get();
      var docList = document.data()!['valuesList'];
      if (document.exists && docList != null) {
        valuesListFromDB = docList;
        valuesListFromDB.add(glucReading);
      } else {
        valuesListFromDB.add(glucReading);
      }
      await _database.collection('glucose').doc(userId).set({
        'valuesList': valuesListFromDB,
      });
      dev.log("Glucose data saved successfully");
      return true;
    } catch (e) {
      dev.log(e.toString());
      dev.log("Failed to save user glucose data");
      return false;
    }
  }

  Future<List?> getGlucoseData() async {
    // gets user id as a string
    // the function will try to fetch the user glucose data from the firebase database
    List? glucUserData;
    String? userID = user!.uid;
    try {
      var document =
          await _database.collection(GLUCOSE_COLLECTION).doc(userID).get();
      glucUserData = document.data()!['valuesList'] as List;
      dev.log(glucUserData.toString());
      return glucUserData;
    } catch (e) {
      dev.log(e.toString());
      dev.log("Failed to get user glucose data");
      return null;
    }
  }
}
