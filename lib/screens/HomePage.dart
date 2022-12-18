import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
 const HomePage({super.key});
  

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        color: Colors.amber[400],
        child: Column(
          children: [
            Container(
              width: deviceWidth * 0.95,
              height: deviceHeight * 0.25,
              child: Card(
                color: Colors.blueGrey[800],
                shadowColor: Colors.blueGrey[600],
                elevation:3, 
                child:Text("This is the Card"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
