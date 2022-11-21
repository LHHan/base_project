import 'package:flutter/material.dart';

import '../values/app_asset.dart';
import '../values/app_colors.dart';

class AppTheme {
  static final AppTheme _singleton = AppTheme._internal();

  factory AppTheme() {
    return _singleton;
  }

  AppTheme._internal();

  /// Light theme
  ThemeData light = ThemeData(
    brightness: Brightness.light,
    fontFamily: AppAssets().fontLato,
  );

  /// Dart theme
  ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    fontFamily: AppAssets().fontLato,
  );
}
