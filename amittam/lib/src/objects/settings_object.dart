import 'dart:convert';

import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:enum_to_string/enum_to_string.dart';

class Settings {
  bool fastLogin;
  Lang lang;

  void apply() {
    Prefs.fastLogin = this.fastLogin;
    Prefs.lang = this.lang;
  }

  Settings.fromMap(Map<String, dynamic> jsonMap)
      : this.fastLogin = jsonMap['fastLogin'],
        this.lang = EnumToString.fromString(Lang.values, jsonMap['lang']);

  factory Settings.fromJson(String json) => Settings.fromMap(jsonDecode(json));

  static Map toMap() => {
    'fastLogin': Prefs.fastLogin,
    'lang': EnumToString.parse(Prefs.lang),
  };

  static String toJson() => json.encode(toMap());
}
