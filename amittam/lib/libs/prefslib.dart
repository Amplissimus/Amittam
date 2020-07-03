import 'package:Amittam/libs/lib.dart';
import 'package:Amittam/objects/password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as crypt;

class Prefs {
  static SharedPreferences preferences;

  static Future<void> initialize() async {
    preferences = await SharedPreferences.getInstance();
  }

  static set firstLogin(bool b) => preferences.setBool('key', b);
  static bool get firstLogin => getBool('first_login', true);

  String getDecryptedMasterPassword(String password) {
    String encryptedPassword =
        preferences.getString('encrypted_master_password');
    if (encryptedPassword == null) return null;
    String decryptedPassword = '';
    try {
      var key = crypt.Key.fromUtf8(password);
      crypt.Encrypter crypter = crypt.Encrypter(crypt.AES(key));
      decryptedPassword = crypter.decrypt(
          crypt.Encrypted.fromBase64(encryptedPassword),
          iv: crypt.IV.fromLength(16));
      return decryptedPassword;
    } catch (e) {
      return errorString(e);
    }
  }

  void setMasterPassword(String password) {
    var key = crypt.Key.fromUtf8(password);
    crypt.Encrypter crypter = crypt.Encrypter(crypt.AES(key));
    String encryptedPassowrd =
        crypter.encrypt(password, iv: crypt.IV.fromLength(16)).base64;
    preferences.setString('encrypted_master_password', encryptedPassowrd);
  }

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
