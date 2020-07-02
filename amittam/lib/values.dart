import 'package:flutter/material.dart';

class CustomColors {
  static bool isDarkMode = false;

  static Color colorForeground = Colors.black;
  static Color colorBackground = Colors.white;
  static Color lightBackground = Color.fromRGBO(220, 220, 220, 1);
  static Color lightForeground = Color.fromRGBO(45, 45, 45, 1);

  static void setMode({@required bool darkMode}) {
    if (darkMode == isDarkMode) return;
    if (darkMode) {
      colorBackground = Colors.black;
      colorForeground = Colors.white;
    } else {
      colorForeground = Colors.black;
      colorBackground = Colors.white;
    }
    isDarkMode = darkMode;
  }
}
