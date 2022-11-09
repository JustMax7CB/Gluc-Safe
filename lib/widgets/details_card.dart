import 'package:flutter/material.dart';

class DetailsCard extends StatelessWidget {
  String? title;
  double width, height;
  Widget child;
  DetailsCard(
      {required this.title,
      required this.width,
      required this.height,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 40.0),
          alignment: Alignment.centerLeft,
          child: Text(
            title!,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: "BebasNeue",
              letterSpacing: 2,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color.fromARGB(253, 166, 165, 165),
            ),
          ),
          child: child,
        )
      ],
    );
  }
}
