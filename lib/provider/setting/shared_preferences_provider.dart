import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/setting.dart';
import 'package:restaurant_app/service/shared_preferences_service.dart';

class SharedPreferencesProvider extends ChangeNotifier {
  final SharedPreferencesService _service;

  SharedPreferencesProvider(this._service);

  String _message = "";
  String get message => _message;

  Setting? _setting;
  Setting? get setting => _setting;

  Future<void> saveSettingValue(Setting value) async {
    try {
      await _service.saveSettingValue(value);
      _message = "Your data is saved";
    } catch (e) {
      _message = "Failed to save your data";
    }
    notifyListeners();
  }

  Future<void> getSettingValue() async {
    try {
      _setting = _service.loadSettingValue();
      _message = "Data successfully retrieved";
    } catch (e) {
      _message = "Failed to get your data";
    }
  }

  ThemeMode getThemeMode() {
    return _setting?.isDarkMode == true ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> updateDarkMode(bool isDarkMode) async {
    if (_setting != null) {
      _setting = Setting(
        isDarkMode: isDarkMode,
        notificationEnable: _setting!.notificationEnable,
      );
      try {
        await _service.saveSettingValue(_setting!);
        _message = "Theme successfully updated";
      } catch (e) {
        _message = "Update data failed";
      }
      notifyListeners();
    }
  }

  Future<void> updateEnable(bool isEnable) async {
    if (_setting != null) {
      _setting = Setting(
        isDarkMode: _setting!.isDarkMode,
        notificationEnable: isEnable,
      );
      try {
        await _service.saveSettingValue(_setting!);
        _message = "Theme successfully updated";
      } catch (e) {
        _message = "Update data failed";
      }
      notifyListeners();
    }
  }
}
