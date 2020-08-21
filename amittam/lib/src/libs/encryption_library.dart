import 'package:Amittam/src/libs/firebaselib.dart';
import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:encrypt/encrypt.dart' as crypt;

class EncryptionService {
  static bool masterPasswordIsValid(String password) {
    List<crypt.Key> tempKeys = [];
    List<crypt.Encrypter> encrypter = [];
    tempKeys.add(crypt.Key.fromUtf8(expandStringTo32Characters(password)));
    for (var key in EncryptionService.getRandomKeysFromPrefs())
      tempKeys.add(key);
    for (var key in tempKeys) print(key.base64);
    for (crypt.Key key in tempKeys)
      encrypter.add(crypt.Encrypter(crypt.AES(key)));
    try {
      if (EncryptionService.decryptFromBase64(
              Prefs.preferences.getString('encrypted_master_password'),
              encrypter) !=
          password) return false;
      EncryptionService.updateKeys(password);
      return true;
    } catch (e) {
      return false;
    }
  }

  static void setMasterPassword(String s) {
    EncryptionService.updateKeys(s, generateNewRandoms: true);
    Prefs.preferences.setString(
        'encrypted_master_password',
        EncryptionService.encryptToBase64(
            s, EncryptionService.getEncrypterFromKeys()));
  }

  static String encryptToBase64(String s, final List<crypt.Encrypter> encrypter) {
    if(s.isEmpty) return '';
    String returnValue = s;
      for (crypt.Encrypter enc in encrypter)
        returnValue =
            enc.encrypt(returnValue, iv: crypt.IV.fromLength(16)).base64;
    return returnValue;
  }

  static String decryptFromBase64(String s, final List<crypt.Encrypter> encrypter) {
    if(s.isEmpty) return '';
    String returnValue = s;
    final iterableEncrypterList = encrypter.reversed.toList();
      for (crypt.Encrypter enc in iterableEncrypterList)
        returnValue = enc.decrypt(crypt.Encrypted.fromBase64(returnValue),
            iv: crypt.IV.fromLength(16));
    return returnValue;
  }

  static List<crypt.Key> _keys = [];
  static List<crypt.Key> get keys => _keys;

  static List<crypt.Encrypter> getEncrypterFromKeys() {
    List<crypt.Encrypter> returnList = [];
    for (crypt.Key key in _keys)
      returnList.add(crypt.Encrypter(crypt.AES(key)));
    return returnList;
  }

  static Future<void> updateKeys(String s,
      {bool generateNewRandoms = false}) async {
    _keys = [];
    if (s == null) return;
    _keys.add(crypt.Key.fromUtf8(expandStringTo32Characters(s)));
    if (!hasExistingRandomKeys() || generateNewRandoms) {
      generateNewRandomKeys(2);
      saveRandomKeysToPrefs();
    } else
      for (var key in getRandomKeysFromPrefs()) _keys.add(key);
    if (FirebaseService.isSignedIn) await saveRandomKeysToFirebase();
    for (var key in _keys) print(key.base64);
  }

  static Future<void> loadRandomKeysFromFirebase() async {
    List<crypt.Key> tempKeys =
        await FirebaseService.getRandomKeysFromFirebase();
    for (var key in _keys) if (_keys.indexOf(key) != 0) _keys.remove(key);
    for (var key in tempKeys) _keys.add(key);
    saveRandomKeysToPrefs();
  }

  static Future<void> saveRandomKeysToFirebase() async {
    for (var key in _keys)
      if (_keys.indexOf(key) != 0)
        await FirebaseService.saveKey(key, _keys.indexOf(key));
  }

  static void saveRandomKeysToPrefs() async {
    for (var key in _keys)
      if (_keys.indexOf(key) != 0)
        await Prefs.preferences
            .setString('key${_keys.indexOf(key)}', key.base64);
  }

  static List<crypt.Key> getRandomKeysFromPrefs() {
    List<crypt.Key> returnList = [];
    bool b = true;
    int i = 0;
    while (b) {
      i++;
      String s = Prefs.preferences.getString('key$i');
      if (s != null)
        returnList.add(crypt.Key.fromBase64(s));
      else
        b = false;
    }
    return returnList;
  }

  static void generateNewRandomKeys(int amount) {
    for (int i = 0; i < amount; i++) _keys.add(crypt.Key.fromSecureRandom(32));
  }

  static bool hasExistingRandomKeys() =>
      Prefs.preferences.getString('key1') != null;
}
