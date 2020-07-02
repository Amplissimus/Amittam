import 'package:Amittam/objects/password.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  SharedPreferences preferences;
  Future<void> initializePrefs() async {
    preferences = await SharedPreferences.getInstance();
  }

  static List<Password> getPasswords() {}
  static void savePasswords(List<Password> passwords) {
    List<String> tempStringList = [];
    for (Password password in passwords) {}
  }
}
