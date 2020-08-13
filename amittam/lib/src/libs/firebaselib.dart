import 'dart:convert';

import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/objects/password.dart';
import 'package:Amittam/src/values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  static FirebaseUser firebaseUser;
  static final firebaseAuth = FirebaseAuth.instance;
  static final FirebaseApp app = FirebaseApp(name: '[DEFAULT]');
  static final FirebaseDatabase firebaseDatabase = FirebaseDatabase(app: app);
  static DatabaseReference generalUserRef;
  static DatabaseReference passwordsRef;
  static DatabaseReference masterPasswordRef;
  static DatabaseReference settingsRef;

  static bool get isSignedIn => firebaseUser != null;

  static Future<void> initialize() async {
    firebaseUser = await firebaseAuth.currentUser();
    if (isSignedIn) _initializeReferences();
  }

  static void _initializeReferences() {
    if (!isSignedIn)
      throw 'User must be signed in for initializing the references';
    generalUserRef =
        firebaseDatabase.reference().child('users').child(firebaseUser.uid);
    passwordsRef = generalUserRef.child('passwords');
    passwordsRef.onValue.listen(
        (event) => getPasswordsFromFirebaseEventSnapshot(event.snapshot));
    masterPasswordRef = generalUserRef.child('masterPassword');
    settingsRef = generalUserRef.child('settings');
  }

  static Future<void> signIn(String phoneNumber, PhoneCodeSent codeSent) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (AuthException authException) =>
          print(authException.message),
      codeSent: codeSent,
      codeAutoRetrievalTimeout: null,
    );
    if (isSignedIn) _initializeReferences();
  }

  static Future<void> signOut() async {
    await firebaseAuth.signOut();
    firebaseUser = null;
    generalUserRef = null;
    passwordsRef = null;
    settingsRef = null;
    masterPasswordRef = null;
  }

  static Future<void> savePasswords(List<Password> passwords) async {
    if (passwordsRef == null) _initializeReferences();
    List<String> tempStringList = [];
    for (Password password in passwords) tempStringList.add(password.toJson());
    await passwordsRef.set(tempStringList);
    await masterPasswordRef
        .set(Prefs.preferences.getString('encrypted_master_password'));
  }
}
