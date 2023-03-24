import 'package:flutter/material.dart';
import 'package:gluc_safe/screens/screens.dart';

PageRouteBuilder registerPageRoute() {
  List<Curve> curveList = [Curves.ease];
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => RegisterPage(),
    transitionDuration: Duration(seconds: 1),
    transitionsBuilder: (context, animation, anotherAnimation, child) {
      animation = CurvedAnimation(curve: curveList[0], parent: animation);
      return SlideTransition(
        position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
            .animate(animation),
        child: child,
      );
    },
  );
}
