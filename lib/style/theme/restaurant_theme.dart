import 'package:flutter/material.dart';
import 'package:restaurant_app/style/colors/restaurant_color.dart';
import 'package:restaurant_app/style/typography/restaurant_text_style.dart';

class RestaurantTheme {

  static ThemeData get lightTheme {
    return ThemeData(
        colorSchemeSeed: RestaurantColors.tale.color,
        brightness: Brightness.light,
        textTheme: _textTheme,
        useMaterial3: true,
        appBarTheme: _appBarTheme
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
        colorSchemeSeed: RestaurantColors.tale.color,
        brightness: Brightness.dark,
        textTheme: _textTheme,
        useMaterial3: true,
        appBarTheme: _appBarTheme
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: restaurantTextTheme.displayLarge,
      displayMedium: restaurantTextTheme.displayMedium,
      displaySmall: restaurantTextTheme.displaySmall,
      headlineLarge: restaurantTextTheme.headlineLarge,
      headlineMedium: restaurantTextTheme.headlineMedium,
      headlineSmall: restaurantTextTheme.headlineSmall,
      titleLarge: restaurantTextTheme.titleLarge,
      titleMedium: restaurantTextTheme.titleMedium,
      titleSmall: restaurantTextTheme.titleSmall,
      bodyLarge: restaurantTextTheme.bodyLarge,
      bodyMedium: restaurantTextTheme.bodyMedium,
      bodySmall: restaurantTextTheme.bodySmall,
      labelLarge: restaurantTextTheme.labelLarge,
      labelMedium: restaurantTextTheme.labelMedium,
      labelSmall: restaurantTextTheme.labelSmall,
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      toolbarTextStyle: _textTheme.titleLarge,
    );
  }
}