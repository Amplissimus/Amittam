import 'package:Amittam/src/libs/uilib.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static FirebaseUser firebaseUser;

  static final firebaseAuth = FirebaseAuth.instance;
  static final googleSignIn = GoogleSignIn();

  static bool isSignedIn = false;

  static Future<void> initialize() async {
    firebaseUser = await firebaseAuth.currentUser();
    if(firebaseUser != null) isSignedIn = true;
  }

  static Future<void> signIn(String phoneNumber, PhoneCodeSent codeSent) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (v) {},
      verificationFailed: (AuthException authException) =>
          print(authException.message),
      codeSent: codeSent,
      codeAutoRetrievalTimeout: null,
    );
  }

  static Future<void> signOut() async {
    firebaseUser = null;
    isSignedIn = false;
    print('Signed out User!');
  }
}
