import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gluc_safe/Models/med_reminder.dart';
import 'package:gluc_safe/Models/glucose.dart';
import 'package:gluc_safe/Models/bolus.dart';
import 'package:gluc_safe/Models/medications.dart';
import 'package:gluc_safe/Models/MedHistory.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:gluc_safe/Models/weight.dart';
import 'package:gluc_safe/Models/workout.dart';
import 'dart:developer' as dev;

const String USER_COLLECTION = 'users';
const String GLUCOSE_COLLECTION = 'glucose';
const String BOLUS_COLLECTION = 'bolus';
const String WEIGHT_COLLECTION = 'weight';
const String MEDICATION_COLLECTION = 'medication';
const String WORKOUT_COLLECTION = 'workout';
const String MEDHISTORY_COLLECTION = 'medHistory';
const String DEVICETOKENS_COLLECTION = 'userTokens';

const String GLUCOSE_RECORDS = 'glucose_records';
const String BOLUS_RECORDS = 'bolus_records';
const String WEIGHT_RECORDS = 'weight_records';
const String MEDICATION_RECORDS = 'medication_records';
const String WORKOUT_RECORDS = 'workout_records';
const String MEDHISTORY_RECORDS = 'medHistory_records';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  FirebaseMessaging _messaging = FirebaseMessaging.instance;

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
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      result.user!.sendEmailVerification();
      return true;
    } catch (e) {
      dev.log(e.toString());
      dev.log("User registration failed");
      return false;
    }
  }

  Future<dynamic> loginUser(
      {required String email, required String password}) async {
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (!_userCredential.user!.emailVerified) {
        await _auth
            .signOut(); // Sign out the user if their email isn't verified
        return "login_page_signin_error_email_not_verified".tr();
      }
      return _userCredential;
    } on FirebaseAuthException catch (e) {
      dev.log("FirebaseAuth code: ${e.code}");
      dev.log("FirebaseAuth message: ${e.message}");
      switch (e.code) {
        case 'user-not-found':
          dev.log('User not found');
          return "login_page_signin_error_user_not_found".tr();
        case 'wrong-password':
          dev.log('Wrong password');
          return "login_page_signin_error_wrong_password".tr();
        case 'invalid-email':
          dev.log("Invalid Email");
          return "login_page_signin_error_invalid_email".tr();
        // Add additional cases for other error codes as needed
        default:
          dev.log('An error occurred: ${e.message}');
          return "login_page_signin_error_occured".tr();
      }
    } catch (e) {
      dev.log('An error occurred: $e');
    }
  }

  Future<bool> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      dev.log("Failed to reset password");
      throw FirebaseAuthException(code: 'auth/user-not-found');
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
    await _auth.currentUser!.updateDisplayName(firstName);
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
      dev.log("Database Service Failed to save user data");
      return false;
    }
  }

  Future<bool> saveUserDeviceToken() async {
    String userId = user!.uid;
    String? token = await _messaging.getToken();
    dev.log(userId);
    try {
      if (token != null) {
        dev.log(token);
        await _database.collection(DEVICETOKENS_COLLECTION).doc(userId).set(
          {
            'token': token,
          },
        );
      }
      return true;
    } catch (e) {
      dev.log("Database Service Failed to save user device token");
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
        .collection(BOLUS_COLLECTION)
        .doc(userID)
        .set({BOLUS_RECORDS: []});
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
    await _database
        .collection(MEDHISTORY_COLLECTION)
        .doc(userID)
        .set({MEDHISTORY_RECORDS: []});
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
      dev.log("Failed to get user medication data");
      return null;
    }
  }

  Future<bool> editMedicationData(
      {required String medicationName,
      required int numOfPills,
      required int perDay,
      required MedReminders reminders}) async {
    List? glucUserMedicationData;
    String userId = user!.uid;

    try {
      var document =
          await _database.collection(MEDICATION_COLLECTION).doc(userId).get();
      glucUserMedicationData = document.data()![MEDICATION_RECORDS] as List;
      for (Map record in glucUserMedicationData) {
        if (record['medicationName'] != medicationName) {
          continue;
        } else {
          record['numOfPills'] = numOfPills;
          record['perDay'] = perDay;
          record['reminders'] = reminders.reminders
              .map((e) => {
                    "Day": e.day.toString().split(".")[1],
                    "Time": ("${e.time.hour}:${e.time.minute}")
                  })
              .toList();
        }
      }

      await _database
          .collection(MEDICATION_COLLECTION)
          .doc(userId)
          .set({MEDICATION_RECORDS: glucUserMedicationData});
      return true;
    } catch (e) {
      dev.log(e.toString());
      dev.log("Failed to update user medication data");
      return false;
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

  Future<bool> saveMedHistoryData(MedHistory medHistoryData) async {
    // gets an instance of MedHistory
    // the function will try to save the medication history data to the firebase database
    List recordsList = [];
    String? userID = user!.uid;
    String medName = medHistoryData.medicationName;
    int numOfPills = medHistoryData.numOfPills;
    DateTime date = medHistoryData.date;
    final medHistoryRecord = {
      'medicationName': medName,
      'numOfPills': numOfPills,
      'date': date,
    };
    try {
      var document =
          await _database.collection(MEDHISTORY_COLLECTION).doc(userID).get();
      var docList = [];
      if (document.exists) {
        docList = document.data()![MEDHISTORY_RECORDS];
      } else {
        await _database
            .collection(MEDHISTORY_COLLECTION)
            .doc(userID)
            .set({MEDHISTORY_RECORDS: []});
      }
      if (document.exists) {
        recordsList = docList;
        recordsList.add(medHistoryRecord);
      } else {
        recordsList.add(medHistoryRecord);
      }
      dev.log(recordsList.toString());
      await _database.collection(MEDHISTORY_COLLECTION).doc(userID).set({
        MEDHISTORY_RECORDS: recordsList,
      });
      dev.log(recordsList.toString());
      dev.log("Medication History data saved successfully");
      return true;
    } catch (e) {
      dev.log(e.toString());
      return false;
    }
  }

  Future<bool> saveBolusData(Bolus bolusData) async {
    // gets an instance of Glucose
    // the function will try to save the glucose data to the firebase database
    // will return true if successful otherwise return false
    List recordsList = [];
    String userId = user!.uid;
    DateTime dataDate = bolusData.date;
    bool dataisMealBolus = bolusData.isMealBolus;
    bool dataisCorrectionBolus = bolusData.isCorrectionBolus;
    double datacarbohydrateIntake = bolusData.carbohydrateIntake;
    double datacarbohydrateRatio = bolusData.carbohydrateRatio;
    double databloodGlucose = bolusData.bloodGlucose;
    double datatargetGlucose = bolusData.targetGlucose;
    double datacorrectionFactor = bolusData.correctionFactor;
    double databolusDose = bolusData.bolusDose;
    final bolusReading = {
      "Date": dataDate,
      "is Meal Bolus": dataisMealBolus,
      "is Correction Bolus": dataisCorrectionBolus,
      "carbohydrate Intake": datacarbohydrateIntake,
      "carbohydrate Ratio": datacarbohydrateRatio,
      "blood Glucose": databloodGlucose,
      "target Glucose": datatargetGlucose,
      "correction Factor": datacorrectionFactor,
      "bolus Dose": databolusDose
    };
    try {
      dev.log((userId == "SUc3GSg9FvNSYj6AhSBpidRgslw1").toString());
      dev.log(_database.collection(BOLUS_COLLECTION).toString());
      var document =
          await _database.collection(BOLUS_COLLECTION).doc(userId).get();
      var docList = document.data()![BOLUS_RECORDS];
      if (document.exists && docList != null) {
        recordsList = docList;
        recordsList.add(bolusReading);
      } else {
        recordsList.add(bolusReading);
      }
      await _database.collection(BOLUS_COLLECTION).doc(userId).set({
        BOLUS_RECORDS: recordsList,
      });
      dev.log("Bolus data saved successfully");
      return true;
    } catch (e) {
      dev.log(e.toString());
      dev.log("Failed to save user bolus data");
      return false;
    }
  }

  Future<List?> getBolusData() async {
    // gets user id as a string
    // the function will try to fetch the user glucose data from the firebase database
    List? bolusUserData;
    String? userID = user!.uid;
    try {
      var document =
          await _database.collection(BOLUS_COLLECTION).doc(userID).get();
      bolusUserData = document.data()![BOLUS_RECORDS] as List;
      bolusUserData.forEach((record) {
        record['Date'] = (record['Date'] as Timestamp).millisecondsSinceEpoch;
      });
      dev.log("\x1B[32m" + bolusUserData.toString());
      return bolusUserData;
    } catch (e) {
      dev.log(e.toString());
      dev.log("Failed to get user bolus data");
      return null;
    }
  }
}
