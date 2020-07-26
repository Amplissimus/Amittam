import 'package:flutter/material.dart';

class Animations {
  static void push(BuildContext context, Object newScreen,
      {Duration duration}) {
    if (duration == null) duration = Duration(milliseconds: 350);
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: duration,
        pageBuilder: (context, animation, secondaryAnimation) => newScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          Animation<Offset> position =
              Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
                  .animate(animation);
          return SlideTransition(position: position, child: child);
        },
      ),
    );
  }

  static void pushReplacement(BuildContext context, Object newScreen,
      {Duration duration}) {
    if (duration == null) duration = Duration(milliseconds: 350);
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: duration,
        pageBuilder: (context, animation, secondaryAnimation) => newScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          Animation<Offset> position =
              Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
                  .animate(animation);
          return SlideTransition(position: position, child: child);
        },
      ),
    );
  }
}
