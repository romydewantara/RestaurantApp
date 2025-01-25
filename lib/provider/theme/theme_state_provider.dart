import 'package:flutter/material.dart';
import 'package:restaurant_app/utils/theme_state.dart';

class ThemeStateProvider extends ChangeNotifier {

  ThemeState _themeState = ThemeState.darkMode;

  ThemeState get themeState => _themeState;

  set themeState(ThemeState value) {
    _themeState = value;
    notifyListeners();
  }
}