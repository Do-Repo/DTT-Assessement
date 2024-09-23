import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  SharedPrefService._privateConstructor();
  static final SharedPrefService _instance =
      SharedPrefService._privateConstructor();
  factory SharedPrefService() {
    return _instance;
  }

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) async {
    if (_prefs == null) await init();
    return await _prefs!.setString(key, value);
  }

  Future<String?> getString(String key) async {
    if (_prefs == null) await init();
    return _prefs!.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    if (_prefs == null) await init();
    return await _prefs!.setBool(key, value);
  }

  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    if (_prefs == null) await init();
    return _prefs!.getBool(key) ?? defaultValue;
  }
}
