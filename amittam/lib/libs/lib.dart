import 'package:Amittam/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void updateBrightness() {
  print('Updating brightness...');
  var brightness = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
      .platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;
  CustomColors.setMode(darkMode: isDarkMode);
  if (Values.afterBrightnessUpdate != null) Values.afterBrightnessUpdate();
}

String errorString(dynamic e) {
  if (e is Error) return '$e\n${e.stackTrace}';
  return e.toString();
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

enum PasswordType {
  onlineAccount,
  emailAccount,
  wlanPassword,
  other,
}
