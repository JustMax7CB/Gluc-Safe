import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gluc_safe/Models/MedReminder.dart';
import 'package:gluc_safe/Models/enums/genders.dart';
import 'package:gluc_safe/Models/glucose.dart';
import 'package:gluc_safe/Models/medications.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:gluc_safe/Models/weight.dart';
import 'package:gluc_safe/Models/workout.dart';
import 'package:gluc_safe/Models/enums/workoutsEnum.dart';
import 'package:path/path.dart' as p;
import 'dart:developer' as dev;

const String USER_COLLECTION = 'users';
const String GLUCOSE_COLLECTION = 'glucose';
const String WEIGHT_COLLECTION = 'weight';
const String MEDICATION_COLLECTION = 'medication';
const String WORKOUT_COLLECTION = 'workout';

const String GLUCOSE_RECORDS = 'glucose_records';
const String WEIGHT_RECORDS = 'weight_records';
const String MEDICATION_RECORDS = 'medication_records';
const String WORKOUT_RECORDS = 'workout_records';

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
      throw FirebaseAuthException(code: 'Log in failed');
    }
  }

  Future<bool> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      dev.log("Failed to reset password");
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
      openUserCollections();
      return true;
    } catch (e) {
      dev.log("Failed to save user data");
      return false;
    }
  }

  Future<void> openUserCollections() async {
    // function to open all the documents for the user in the database

    String? userID = user!.uid;
    await _database
        .collection(GLUCOSE_COLLECTION)
        .doc(userID)
        .set({GLUCOSE_RECORDS: []});
    await _database
        .collection(WEIGHT_COLLECTION)
        .doc(userID)
        .set({WEIGHT_RECORDS: []});
    await _database
        .collection(MEDICATION_COLLECTION)
        .doc(userID)
        .set({MEDICATION_RECORDS: []});
    await _database
        .collection(WORKOUT_COLLECTION)
        .doc(userID)
        .set({WORKOUT_RECORDS: []});
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
      dev.log("User Document doesn't exist or failed to retrieve data");
      return null;
    }
  }

  Future<void> logout() async {
    // the function will try to log out the user
    // if successful user will be logged out otherwise exception will be thrown
    try {
      await _auth.signOut();
    } catch (e) {
      dev.log("Logout Failed");
    }
  }

  Future<bool> saveGlucoseData(Glucose glucoseData) async {
    // gets an instance of Glucose
    // the function will try to save the glucose data to the firebase database
    // will return true if successful otherwise return false
    List recordsList = [];
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
      var document =
          await _database.collection(GLUCOSE_COLLECTION).doc(userId).get();
      var docList = document.data()![GLUCOSE_RECORDS];
      if (document.exists && docList != null) {
        recordsList = docList;
        recordsList.add(glucReading);
      } else {
        recordsList.add(glucReading);
      }
      await _database.collection(GLUCOSE_COLLECTION).doc(userId).set({
        GLUCOSE_RECORDS: recordsList,
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
      glucUserData = document.data()![GLUCOSE_RECORDS] as List;
      glucUserData.forEach((record) {
        record['Date'] = (record['Date'] as Timestamp).millisecondsSinceEpoch;
      });
      // dev.log("\x1B[32m" + glucUserData.toString());
      return glucUserData;
    } catch (e) {
      dev.log(e.toString());
      dev.log("Failed to get user glucose data");
      return null;
    }
  }

  Future<bool> saveMedicationData(Medication medicationData) async {
    // gets an instance of Medication
    // the function will try to save the medication data to the firebase database
    List recordsList = [];
    String? userID = user!.uid;
    String medName = medicationData.medicationName;
    int numOfPills = medicationData.numOfPills;
    int perDay = medicationData.perDay;
    MedReminders reminders = medicationData.reminders;
    final medicationRecord = {
      'medicationName': medName,
      'numOfPills': numOfPills,
      'perDay': perDay,
      //'reminders': reminders,
      'reminders': reminders.reminders
          .map((e) => {
                "Day": e.day.toString().split(".")[1],
                "Time": ("${e.time.hour}:${e.time.minute}")
              })
          .toList(),
    };
    try {
      var document =
          await _database.collection(MEDICATION_COLLECTION).doc(userID).get();
      var docList = document.data()![MEDICATION_RECORDS];
      if (document.exists && docList != null) {
        recordsList = docList;
        recordsList.add(medicationRecord);
      } else {
        recordsList.add(medicationRecord);
      }
      dev.log(recordsList.toString());
      await _database.collection(MEDICATION_COLLECTION).doc(userID).set({
        MEDICATION_RECORDS: recordsList,
      });
      dev.log(recordsList.toString());
      dev.log("Medication data saved successfully");
      return true;
    } catch (e) {
      dev.log(e.toString());
      return false;
    }
  }

  Future<List?> getMedicationData() async {
    // gets user id as a string
    // the function will try to fetch the user medication data from the firebase database
    List? glucUserMedicationData;
    String? userID = user!.uid;
    try {
      var document =
          await _database.collection(MEDICATION_COLLECTION).doc(userID).get();
      glucUserMedicationData = document.data()![MEDICATION_RECORDS] as List;
      dev.log(glucUserMedicationData.toString());
      return glucUserMedicationData;
    } catch (e) {
      dev.log(e.toString());
      dev.log("Failed to get user glucose data");
      return null;
    }
  }

  Future<bool> saveWeightData(Weight weightData) async {
    List recordsList = [];
    String userId = user!.uid;
    DateTime dataDate = weightData.date;
    int dataWeight = weightData.weight;
    final weightReading = {
      "Date": dataDate,
      "Weight": dataWeight,
    };
    try {
      var document =
          await _database.collection(WEIGHT_COLLECTION).doc(userId).get();
      var docList = document.data()![WEIGHT_RECORDS];
      if (document.exists && docList != null) {
        recordsList = docList;
        recordsList.add(weightReading);
      } else {
        recordsList.add(weightReading);
      }
      await _database.collection(WEIGHT_COLLECTION).doc(userId).set({
        WEIGHT_RECORDS: recordsList,
      });
      dev.log("Weight data saved successfully");
      return true;
    } catch (e) {
      dev.log(e.toString());
      dev.log("Failed to save user weight data");
      return false;
    }
  }

  Future<List?> getWeightData() async {
    // gets user id as a string
    // the function will try to fetch the user glucose data from the firebase database
    List? weightUserData;
    String? userID = user!.uid;
    try {
      var document =
          await _database.collection(WEIGHT_COLLECTION).doc(userID).get();
      weightUserData = document.data()![WEIGHT_RECORDS] as List;
      dev.log(weightUserData.toString());
      return weightUserData;
    } catch (e) {
      dev.log(e.toString());
      dev.log("Failed to get user weight data");
      return null;
    }
  }

  Future<bool> saveWorkoutData(Workout workoutData) async {
    List recordsList = [];
    String userId = user!.uid;
    DateTime dataDate = workoutData.date;
    String workoutType = workoutData.workoutType.toString().split('.')[1];
    int durationData = workoutData.duration;
    int? distanceData = workoutData.distance;
    final workoutReading = {
      "Date": dataDate,
      "workoutType": workoutType,
      "Duration": durationData,
      "Distance": distanceData,
    };
    try {
      var document =
          await _database.collection(WORKOUT_COLLECTION).doc(userId).get();
      var docList = document.data()![WORKOUT_RECORDS];
      if (document.exists && docList != null) {
        recordsList = docList;
        recordsList.add(workoutReading);
      } else {
        recordsList.add(workoutReading);
      }
      await _database.collection(WORKOUT_COLLECTION).doc(userId).set({
        WORKOUT_RECORDS: recordsList,
      });
      dev.log("Workout data saved successfully");
      return true;
    } catch (e) {
      dev.log(e.toString());
      dev.log("Failed to save user workout data");
      return false;
    }
  }

  Future<List?> getWorkoutData() async {
    // gets user id as a string
    // the function will try to fetch the user glucose data from the firebase database
    List? workoutUserData;
    String? userID = user!.uid;
    try {
      var document =
          await _database.collection(WORKOUT_COLLECTION).doc(userID).get();
      workoutUserData = document.data()![WORKOUT_RECORDS] as List;
      dev.log(workoutUserData.toString());
      return workoutUserData;
    } catch (e) {
      dev.log(e.toString());
      dev.log("Failed to get user workout data");
      return null;
    }
  }
}
