import 'package:money_tracker/auth/google_auth_service.dart';
import 'package:money_tracker/auth/iauth_service.dart';
import 'package:money_tracker/const/auth_types.dart';
import 'package:money_tracker/shared_services/shared_preferences_service.dart';

class AuthenticationController {
  static String authTypeKey = "authType";
  late String? currentAuthType;
  late final Map<String, IAuthenticationService> _authServices =
      <String, IAuthenticationService>{};
  AuthenticationController._privateContructor() {
    _authServices[googleAuth] = GoogleAuthenticationService();
    // To get the authentication type of currently logged in user
    currentAuthType = SharedPreferencesService().getString(authTypeKey);
  }

  static final AuthenticationController _instance =
      AuthenticationController._privateContructor();

  factory AuthenticationController() {
    return _instance;
  }
  void handleSignIn(String authType) async {
    currentAuthType = authType;
    //Setting current authentication type in Shared preferences
    SharedPreferencesService().setString(authTypeKey, authType);
    IAuthenticationService? authService = _authServices[authType];
    if (authService != null) {
      authService.handleSignIn();
    } else {
      print("Error in handling Sign in");
    }
  }

  void handleSignOut() async {
    IAuthenticationService? authService = _authServices[currentAuthType];
    if (authService != null) {
      authService.handleSignOut();
    } else {
      print("Error in handling Sign Out");
    }
  }
}
