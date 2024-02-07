import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _keyHasPermission = 'hasPermission';

  Future<bool> getHasPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasPermission) ?? false;
  }

  Future<void> setHasPermission(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_keyHasPermission, value);
  }
}