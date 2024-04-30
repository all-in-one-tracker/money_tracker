import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  AuthenticationService._privateConstructor();

  static final AuthenticationService _instance =
      AuthenticationService._privateConstructor();
  factory AuthenticationService() {
    return _instance;
  }
  void handleGoogleSignIn() {
    _GoogleAuthenticationService().handleSignIn();
  }

  void handleGoogleSignOut() {
    _GoogleAuthenticationService().handleSignOut();
  }
}

class _GoogleAuthenticationService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  _GoogleAuthenticationService._privateConstructor();

  static final _GoogleAuthenticationService _instance =
      _GoogleAuthenticationService._privateConstructor();
  factory _GoogleAuthenticationService() {
    return _instance;
  }

  void handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (error) {
      print(error);
    }
  }

  void handleSignOut() async {
    await FirebaseAuth.instance.signOut();
    //need to sign out from Google as well in order to let user select the account while logging in again
    //else the last logged in user account will be used for logging in
    await _googleSignIn.signOut();
  }
}
