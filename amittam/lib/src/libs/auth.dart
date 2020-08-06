import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static FirebaseUser firebaseUser;

  static final _firebaseAuth = FirebaseAuth.instance;
  static final googleSignIn = GoogleSignIn();

  static bool isSignedIn = false;

  static Future<void> signIn() async {
    final googleSignInAccount = await googleSignIn.signIn();
    final googleSignInAuthentication = await googleSignInAccount.authentication;

    final credentials = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final _authResult = await _firebaseAuth.signInWithCredential(credentials);
    firebaseUser = _authResult.user;
    isSignedIn = true;
    print('Signed in User!');
  }

  static Future<void> signOut() async {
    await googleSignIn.signOut();
    firebaseUser = null;
    isSignedIn = false;
    print('Signed out User!');
  }
}
