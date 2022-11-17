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
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColors().colorBackground,
      onPrimary: Colors.white,
      secondary: Colors.black,
      onSecondary: Colors.blue,
    ),
    fontFamily: AppAssets().fontLato,
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.black,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        color: Color(0xFF0D152E),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      bodyText1: TextStyle(
        color: Color(0xFF0D152E),
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyText2: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      caption: TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      button: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      labelStyle: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      errorStyle: TextStyle(
        color: Colors.red,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: Color(0xFFF4F5F6), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: Colors.black, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
    ),
    toggleableActiveColor: Colors.blue,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: const BorderSide(
              style: BorderStyle.solid,
              color: Colors.black,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        side: MaterialStateProperty.all(
          const BorderSide(
            style: BorderStyle.solid,
            color: Colors.black,
            width: 1,
          ),
        ),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 11, horizontal: 32)),
        minimumSize: MaterialStateProperty.all(const Size(120, 40)),
        elevation: MaterialStateProperty.all(0),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: const BorderSide(
                style: BorderStyle.solid, color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 11, horizontal: 32)),
        minimumSize: MaterialStateProperty.all(const Size(109, 40)),
        elevation: MaterialStateProperty.all(0),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.grey,
      // indicator: ShapeDecoration(
      //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      //             color: Colors.white,
      //           )
    ),
  );
}
