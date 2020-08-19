import 'dart:io';

import 'package:Amittam/src/objects/displayable_password.dart';
import 'package:Amittam/src/objects/password.dart';
import 'package:flutter/material.dart';

import 'objects/langs/english.dart';
import 'objects/langs/german.dart';
import 'objects/language.dart';

Language getLangByLocaleName() {
  switch (Platform.localeName.split('_')[0]) {
    case 'de':
      return German();
    default:
      return English();
  }
}

class CustomColors {
  static bool get isDarkMode => _isDarkMode;
  static bool _isDarkMode = false;

  static Color get colorForeground => _isDarkMode ? Colors.white : Colors.black;

  static Color get colorBackground => _isDarkMode ? Colors.black : Colors.white;

  static Color get lightBackground => _isDarkMode
      ? Color.fromRGBO(45, 45, 45, 1)
      : Color.fromRGBO(220, 220, 220, 1);

  static Color get lightForeground => _isDarkMode
      ? Color.fromRGBO(220, 220, 220, 1)
      : Color.fromRGBO(45, 45, 45, 1);

  static void setMode({@required bool darkMode}) => _isDarkMode = darkMode;
}

class Strings {
  static String get appTitle => 'Amittam';
}

class Values {
  static List<DisplayablePassword> displayablePasswords = [];
  static List<DecryptedPassword> decryptedPasswords = [];
  static List<Password> passwords = [];
  static void Function() tempRebuildFunction = () {};

  static const green15 = Color.fromRGBO(0, 255, 0, 0.15);
}
