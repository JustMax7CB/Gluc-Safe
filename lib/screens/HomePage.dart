import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:get_it/get_it.dart';
import 'package:gluc_safe/Models/user.dart';
import 'package:gluc_safe/services/database.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;

class HomePage extends StatelessWidget {
  HomePage({super.key, required this.glucUser});
  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();
  final FirebaseService _firebaseService =
      GetIt.instance.get<FirebaseService>();

  GlucUser glucUser;
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        color: Colors.amber[400],
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: SimpleFoldingCell.create(
            cellSize: Size(deviceWidth * 0.9, deviceHeight * 0.2),
            key: _foldingCellKey,
            frontWidget: GestureDetector(
              child: _buildFrontWidget(),
              onTap: () {
                _foldingCellKey.currentState!.toggleFold();
                getLatestGlucoseValue();
              },
            ),
            innerWidget: GestureDetector(
              child: _buildInnerWidget(),
              onTap: () => _foldingCellKey.currentState!.toggleFold(),
            ),
            padding: EdgeInsets.all(15),
            animationDuration: Duration(milliseconds: 300),
            borderRadius: 20,
            onOpen: () {},
            onClose: () {},
          ),
        ),
      ),
    );
  }

  Widget _buildFrontWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          border:
              Border.all(width: 5, color: Color.fromARGB(255, 227, 164, 5))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Your average glucose value",
              style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w400)),
          FutureBuilder(
            future: getGlucoseAverage(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  "${snapshot.data}",
                  style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                );
              }
              return Text("");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInnerWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 67, 134, 210),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border:
              Border.all(width: 5, color: Color.fromARGB(255, 227, 164, 5))),
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                "Latest Glucose",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              FutureBuilder(
                future: getLatestGlucoseValue(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('${snapshot.data}',
                        style: TextStyle(fontSize: 40, color: Colors.white));
                  }
                  return Text("");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future glucoseValuesListFromFirebase() async =>
      await _firebaseService.getGlucoseData();

  Future<double> getGlucoseAverage() async {
    List glucoseValues = await glucoseValuesListFromFirebase()
        .then((response) => response.map((e) => e['Glucose']).toList());
    double sum = 0;
    for (var val in glucoseValues) {
      sum = sum + val;
    }
    return sum / glucoseValues.length;
  }

  Future<int> getLatestGlucoseValue() async {
    // return a list of glucose values in the format (Glucose value, Date value saved)
    List? userGlucoseRecords = await glucoseValuesListFromFirebase()
        .then((response) => sortDateString(response));
    // dev.log(userGlucoseRecords.toString());
    if (userGlucoseRecords != null && userGlucoseRecords.length > 0) {
      return userGlucoseRecords[userGlucoseRecords.length - 1]['Glucose'];
    }
    return 0;
  }

  List sortDateString(List userGlucoseRecords) {
    //dev.log(userGlucoseRecords.toString());
    userGlucoseRecords.sort((a, b) => a['Date'].compareTo(b['Date']));
    return userGlucoseRecords;
  }
}
