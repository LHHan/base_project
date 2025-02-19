import 'package:base_project_getx/app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

import 'app_asset.dart';

class AppTheme {
  static final AppTheme _singleton = AppTheme._internal();

  factory AppTheme() {
    return _singleton;
  }

  AppTheme._internal();

  /// Light theme
  ThemeData light = ThemeData(
    fontFamily: AppAssets().fontRoboto,
    textTheme: const TextTheme(),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors().seedColorLight,
      brightness: Brightness.light,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(),
      },
    ),
  );

  /// Dart theme
  ThemeData dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors().seedColorDark,
      brightness: Brightness.dark,
    ),
    fontFamily: AppAssets().fontRoboto,
    textTheme: const TextTheme(),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(),
      },
    ),
  );
}
