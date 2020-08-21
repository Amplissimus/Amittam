import 'dart:async';

import 'package:Amittam/src/libs/encryption_library.dart';
import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/objects/password.dart';
import 'package:Amittam/src/objects/settings_object.dart';
import 'package:Amittam/src/screens/home.dart';
import 'package:Amittam/src/values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:encrypt/encrypt.dart' as crypt;

class FirebaseService {
  static FirebaseUser firebaseUser;
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final FirebaseApp app = FirebaseApp(name: '[DEFAULT]');
  static final FirebaseDatabase firebaseDatabase = FirebaseDatabase(app: app);

  static final GoogleSignIn googleSignIn = GoogleSignIn();

  static DatabaseReference generalUserRef;
  static DatabaseReference passwordsRef;
  static DatabaseReference masterPasswordRef;
  static DatabaseReference settingsRef;
  static DatabaseReference keysRef;

  static bool get isSignedIn => firebaseUser != null;

  static Future<void> initialize() async {
    firebaseUser = await firebaseAuth.currentUser();
    if (isSignedIn) _initializeReferences();
    if (await internetConnectionAvailable() &&
        Prefs.allowRetrievingCloudData &&
        isSignedIn) {
      await loadSettings();
      await retrievePasswords();
    } else if (isSignedIn)
      await signOut();
    else
      Prefs.allowRetrievingCloudData = false;
  }

  static void _initializeReferences() {
    if (!isSignedIn)
      throw 'User must be signed in for initializing the references';
    generalUserRef =
        firebaseDatabase.reference().child('users').child(firebaseUser.uid);
    passwordsRef = generalUserRef.child('passwords');
    passwordsRef.onValue.listen(
        (event) => getPasswordsFromFirebaseEventSnapshot(event.snapshot));
    masterPasswordRef = generalUserRef.child('encryptedMasterPassword');
    settingsRef = generalUserRef.child('settings');
    keysRef = generalUserRef.child('keys');
  }

  static Future<void> signInWithGoogle() async {
    final googleAccount = await googleSignIn.signIn();
    final googleAuthentication = await googleAccount.authentication;
    final authResult = await firebaseAuth.signInWithCredential(
      GoogleAuthProvider.getCredential(
        accessToken: googleAuthentication.accessToken,
        idToken: googleAuthentication.idToken,
      ),
    );
    final user = authResult.user;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    firebaseUser = await firebaseAuth.currentUser();
    _initializeReferences();
  }

  static Future<void> signOut() async {
    await firebaseAuth.signOut();
    firebaseUser = null;
    generalUserRef = null;
    passwordsRef = null;
    settingsRef = null;
    masterPasswordRef = null;
    Prefs.allowRetrievingCloudData = false;
  }

  static Future<void> savePasswords(List<Password> passwords) async {
    if (passwordsRef == null) _initializeReferences();
    List<String> tempStringList = [];
    for (Password password in passwords)
      tempStringList.add(password.toEncryptedJson());
    await passwordsRef.set(tempStringList);
    await masterPasswordRef
        .set(Prefs.preferences.getString('encrypted_master_password'));
    await EncryptionService.saveRandomKeysToFirebase();
  }

  static Future<bool> hasExistingData() async {
    bool b = false;
    await masterPasswordRef
        .once()
        .then((snapshot) => b = snapshot.value != null);
    return b;
  }

  static Future<void> retrievePasswords() async {
    if (!Prefs.allowRetrievingCloudData) return;
    await passwordsRef
        .once()
        .then((snapshot) => getPasswordsFromFirebaseEventSnapshot(snapshot));
  }

  static Future<void> getPasswordsFromFirebaseEventSnapshot(
      DataSnapshot dataSnapshot) async {
    if (!Prefs.allowRetrievingCloudData) return;
    int i = 0;
    bool b = true;
    List<String> tempStringList = [];
    List<Password> tempPasswordList = [];
    while (b)
      try {
        tempStringList.add(EncryptionService.decryptFromBase64(
            dataSnapshot.value[i].toString(),
            EncryptionService.getEncrypterFromKeys()));
        tempPasswordList.add(Password.fromDecryptedJson(dataSnapshot.value[i]));
        i++;
      } catch (e) {
        b = false;
      }
    Prefs.preferences.setStringList('passwords', tempStringList);
    Values.passwords = tempPasswordList;
    await FirebaseService.masterPasswordRef.once().then((snapshot) =>
        Prefs.preferences.setString(
            'encrypted_master_password', snapshot.value.toString().trim()));
    if (HomePage.updateHomePage != null) HomePage.updateHomePage();
  }

  static Future<String> storedMasterPassword() async {
    String s;
    await masterPasswordRef
        .once()
        .then((snapshot) => s = snapshot.value.toString().trim());
    return s;
  }

  static Future<void> saveSettings() async =>
      await settingsRef.set(Settings.toJson());

  static Future<void> loadSettings() async {
    if (!Prefs.allowRetrievingCloudData) return;
    await settingsRef.once().then(
        (snapshot) => Settings.fromJson(snapshot.value.toString()).apply());
  }

  static Future<void> deleteOnlineData() async {
    if (generalUserRef == null) _initializeReferences();
    await generalUserRef.set(null);
  }

  static Future<void> saveData() async {
    await savePasswords(Prefs.passwords);
    await saveSettings();
  }

  static Future<void> loadData() async {
    await retrievePasswords();
    await loadSettings();
  }

  static Future<void> saveKey(crypt.Key key, int index) async {
    await keysRef.child('key$index').set(key.base64);
  }

  static Future<List<crypt.Key>> getRandomKeysFromFirebase() async {
    List<crypt.Key> returnList = [];
    bool b = true;
    int i = 0;
    while (b) {
      i++;
      String s;
      await keysRef.child('key$i').once().then((sn) => s = sn.value);
      if (s != null)
        returnList.add(crypt.Key.fromBase64(s));
      else
        b = false;
    }
    return returnList;
  }
}
