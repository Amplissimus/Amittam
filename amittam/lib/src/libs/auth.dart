import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static FirebaseUser _firebaseUser;

  static final _firebaseAuth = FirebaseAuth.instance;
  static final _googleSignIn = GoogleSignIn();

  static Future<void> googleSignIn() async {
    final googleSignInAccount = await _googleSignIn.signIn();
    final googleSignInAuthentication = await googleSignInAccount.authentication;

    final credentials = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final _authResult = await _firebaseAuth.signInWithCredential(credentials);
    _firebaseUser = _authResult.user;
  }

  static void googleSignOut() async {
    await _googleSignIn.signOut();
    _firebaseUser = null;
  }
}
