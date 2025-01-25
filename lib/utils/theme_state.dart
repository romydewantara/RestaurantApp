enum ThemeState {
  darkMode,
  lightMode;

  bool get isDarkMode => this == ThemeState.darkMode;
}

extension BoolExtension on bool {
  ThemeState get isDarkMode =>
      this == true ? ThemeState.darkMode : ThemeState.lightMode;
}
