import 'package:flutter/material.dart';

import 'app_asset.dart';
import 'app_colors.dart';

class AppTheme {
  static final AppTheme _singleton = AppTheme._internal();

  factory AppTheme() {
    return _singleton;
  }

  AppTheme._internal();

  /// Light theme
  ThemeData light = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors().colorPrimary,
      onPrimary: Colors.white,
      secondary: AppColors().colorSecondary,
      onSecondary: Colors.white,
      error: AppColors().colorError,
      onError: Colors.white,
      background: AppColors().colorBackground,
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    fontFamily: AppAssets().fontRoboto,
  );

  /// Dart theme
  ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    fontFamily: AppAssets().fontRoboto,
  );
}
