import 'dart:convert';

import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:enum_to_string/enum_to_string.dart';

class Settings {
  bool fastLogin;
  Lang lang;
  bool useDarkTheme;
  bool useSystemTheme;

  void apply() {
    Prefs.useDarkTheme = this.useDarkTheme;
    Prefs.useSystemTheme = this.useSystemTheme;
    Prefs.fastLogin = this.fastLogin;
    Prefs.lang = this.lang;
  }

  Settings.fromMap(Map<String, dynamic> jsonMap)
      : this.useDarkTheme = jsonMap['useDarkTheme'],
        this.useSystemTheme = jsonMap['useSystemTheme'],
        this.fastLogin = jsonMap['fastLogin'],
        this.lang = EnumToString.fromString(Lang.values, jsonMap['lang']);

  factory Settings.fromJson(String json) => Settings.fromMap(jsonDecode(json));

  static Map toMap() => {
        'useDarkTheme': Prefs.useDarkTheme,
        'useSystemTheme': Prefs.useSystemTheme,
        'fastLogin': Prefs.fastLogin,
        'lang': EnumToString.parse(Prefs.lang),
      };

  static String toJson() => json.encode(toMap());
}
