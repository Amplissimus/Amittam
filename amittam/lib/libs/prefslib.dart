import 'package:Amittam/libs/lib.dart';
import 'package:Amittam/objects/password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as crypt;

class Prefs {
  static SharedPreferences preferences;

  static Future<void> initialize() async {
    preferences = await SharedPreferences.getInstance();
  }

  static set firstLogin(bool b) => preferences.setBool('first_login', b);
  static bool get firstLogin => getBool('first_login', true);

  static String getDecryptedMasterPassword(String password) {
    String encryptedPassword =
        preferences.getString('encrypted_master_password');
    if (encryptedPassword == null) return null;
    String decryptedPassword = '';
    try {
      Password.key = crypt.Key.fromUtf8(expandStringTo32Characters(password));
      crypt.Encrypter crypter = crypt.Encrypter(crypt.AES(Password.key));
      decryptedPassword = crypter.decrypt(
          crypt.Encrypted.fromBase64(encryptedPassword),
          iv: crypt.IV.fromLength(16));
      print('decryptedPassword: $decryptedPassword');
      return decryptedPassword;
    } catch (e) {
      return errorString(e);
    }
  }

  static void setMasterPassword(String password) {
    Password.key = crypt.Key.fromUtf8(expandStringTo32Characters(password));
    crypt.Encrypter crypter = crypt.Encrypter(crypt.AES(Password.key));
    String encryptedPassword =
        crypter.encrypt(password, iv: crypt.IV.fromLength(16)).base64;
    preferences.setString('encrypted_master_password', encryptedPassword);
    preferences.setString('encryption_master_pw_validation_test',
        crypter.encrypt('validationTest', iv: crypt.IV.fromLength(16)).base64);
    print('encryptedPassword: $encryptedPassword');
  }

  static bool masterPasswordIsValid(String password) {
    try {
      Password.key = crypt.Key.fromUtf8(expandStringTo32Characters(password));
      crypt.Encrypter crypter = crypt.Encrypter(crypt.AES(Password.key));
      String encryptedValidationTest =
          preferences.getString('encryption_master_pw_validation_test');
      if (crypter
              .decrypt(crypt.Encrypted.fromBase64(encryptedValidationTest),
                  iv: crypt.IV.fromLength(16))
              .trim() !=
          'validationTest') return false;
      print('master password is valid');
      return true;
    } catch (e) {
      print(errorString(e));
      return false;
    }
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
