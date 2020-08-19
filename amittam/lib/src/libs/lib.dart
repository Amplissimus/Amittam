import 'dart:io';

import 'package:Amittam/main.dart';
import 'package:Amittam/src/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



String errorString(dynamic e) {
  if (e is Error) return '$e\n${e.stackTrace}';
  return e.toString();
}

Color stringToColor(String string, {Color defaultValue = Colors.green}) {
  Color returnValue;
  string = string.toLowerCase();
  switch (string) {
    case 'green':
      returnValue = Colors.green;
      break;
    case 'red':
      returnValue = Colors.red;
      break;
    case 'blue':
      returnValue = Colors.blue;
      break;
    case 'orange':
      returnValue = Colors.orange;
      break;
    case 'yellow':
      returnValue = Colors.yellow;
      break;
    case 'brown':
      returnValue = Colors.brown;
      break;
    case 'cyan':
      returnValue = Colors.cyan;
      break;
    case 'pink':
      returnValue = Colors.pink;
      break;
    case 'grey':
      returnValue = Colors.grey;
      break;
    default:
      returnValue = defaultValue;
      break;
  }
  return returnValue;
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

enum PasswordType {
  onlineAccount,
  emailAccount,
  wifiPassword,
  other,
}

Future<bool> internetConnectionAvailable() async {
  try{
    final result = await InternetAddress.lookup('google.com');
    if(result.isNotEmpty && result[0].rawAddress.isNotEmpty) return true;
    return false;
  } catch(e) {
    return false;
  }
}
