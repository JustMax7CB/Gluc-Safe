import 'package:flutter/material.dart';

List<Shadow> textStroke(double width, Color color) {
  return <Shadow>[
    Shadow(
      color: color,
      blurRadius: 0,
      offset: Offset(-width, -width),
    ),
    Shadow(
      color: color,
      blurRadius: 0,
      offset: Offset(width, -width),
    ),
    Shadow(
      color: color,
      blurRadius: 0,
      offset: Offset(width, width),
    ),
    Shadow(
      color: color,
      blurRadius: 0,
      offset: Offset(-width, width),
    ),
  ];
}
