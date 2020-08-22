import 'dart:io';

import 'package:Amittam/src/objects/displayable_password.dart';
import 'package:Amittam/src/objects/password.dart';
import 'package:flutter/material.dart';

import 'objects/langs/english.dart';
import 'objects/langs/german.dart';
import 'objects/language.dart';



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
