import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_tracker/auth/iauth_service.dart';

class GoogleAuthenticationService implements IAuthenticationService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleAuthenticationService._privateConstructor();

  static final GoogleAuthenticationService _instance =
      GoogleAuthenticationService._privateConstructor();
  factory GoogleAuthenticationService() {
    return _instance;
  }

  @override
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

  @override
  void handleSignOut() async {
    await FirebaseAuth.instance.signOut();
    //need to sign out from Google as well in order to let user select the account while logging in again
    //else the last logged in user account will be used for logging in
    await _googleSignIn.signOut();
  }
}
