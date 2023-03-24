import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key, required this.start, required this.end});
  final double start;
  final double end;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 20,
      thickness: 2,
      indent: start,
      endIndent: end,
      color: Colors.grey,
    );
  }
}