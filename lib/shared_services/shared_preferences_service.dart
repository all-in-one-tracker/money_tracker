import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  late SharedPreferences _sharedPreferences;
  SharedPreferencesService._privateConstructor();

  static final SharedPreferencesService _instance =
      SharedPreferencesService._privateConstructor();

  factory SharedPreferencesService() {
    return _instance;
  }

  void setSharedPreference() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  String? getString(String key) {
    return _sharedPreferences.getString(key);
  }

  void setString(String key, String value) {
    _sharedPreferences.setString(key, value);
  }
}
