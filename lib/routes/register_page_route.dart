import 'package:flutter/material.dart';
import 'package:gluc_safe/screens/register_page.dart';

PageRouteBuilder registerPageRoute() {
  List<Curve> curveList = [Curves.ease];
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => const RegisterPage(),
    transitionDuration: const Duration(seconds: 1),
    transitionsBuilder: (context, animation, anotherAnimation, child) {
      animation = CurvedAnimation(curve: curveList[0], parent: animation);
      return SlideTransition(
        position:
            Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
                .animate(animation),
        child: child,
      );
    },
  );
}
