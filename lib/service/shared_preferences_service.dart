import 'package:restaurant_app/data/model/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String _keyAppTheme = "MY_APP_THEME";
  static const String _keyNotification = "MY_NOTIFICATION";

  Future<void> saveSettingValue(Setting setting) async {
    try {
      await _preferences.setBool(_keyAppTheme, setting.isDarkMode);
      await _preferences.setBool(_keyNotification, setting.notificationEnable);
    } catch (e) {
      throw Exception("Shared preferences cannot load the setting app theme.");
    }
  }

  Setting loadSettingValue() {
    return Setting(
      isDarkMode: _preferences.getBool(_keyAppTheme) ?? false,
      notificationEnable: _preferences.getBool(_keyNotification) ?? false,
    );
  }
}
