import 'package:Amittam/objects/password.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static SharedPreferences preferences;
  Future<void> initializePrefs() async {
    preferences = await SharedPreferences.getInstance();
  }

  static set firstLogin(bool b) => preferences.setBool('key', b);
  static bool get firstLogin => getBool('first_login', true);

  static List<Password> getPasswords() {
    List<Password> tempPasswords = [];
    List<String> tempStringList = getStringList('key', []);
    for (String tempString in tempStringList) {
      tempPasswords.add(Password.fromJson(tempString));
    }
    return tempPasswords;
  }

  static void savePasswords(List<Password> passwords) {
    List<String> tempStringList = [];
    for (Password password in passwords) {
      tempStringList.add(password.toJson());
    }
    preferences.setStringList('key', tempStringList);
  }

  static getBool(String key, bool standardValue) {
    bool returnValue = preferences.getBool(key);
    if (returnValue == null) return standardValue;
    return returnValue;
  }

  static List<String> getStringList(String key, List<String> standardValue) {
    List<String> tempStringList = preferences.getStringList(key);
    if (tempStringList == null) return standardValue;
    return standardValue;
  }
}
