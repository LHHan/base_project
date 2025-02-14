import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    fontFamily: AppAssets().fontRoboto,
    // you can custom something here (pageTransitionsTheme, buttonTheme, textTheme,..)
  );

  /// Dart theme
  ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    fontFamily: AppAssets().fontRoboto,
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.gruppo(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors().textColor,
      ),
      bodyMedium: GoogleFonts.gruppo(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: AppColors().textColor,
      ),
      bodySmall: GoogleFonts.montserrat(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors().textColor,
      ),
      displayLarge: GoogleFonts.buda(
        fontSize: 70,
        color: AppColors().textColor,
      ),
      displayMedium: GoogleFonts.buda(
        fontSize: 50,
        color: AppColors().textColor,
      ),
      displaySmall: GoogleFonts.buda(
        fontSize: 40,
        color: AppColors().textColor,
      ),
    ),

    // you can custom something here (pageTransitionsTheme, buttonTheme, textTheme,..)
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
    iconTheme: IconThemeData(color: AppColors().textColor),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        textStyle: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors().selectedColor,
      inactiveTrackColor: AppColors().trackColor,
      thumbColor: AppColors().selectedColor,
      trackHeight: 2,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedIconTheme: const IconThemeData(size: 40),
      unselectedIconTheme: const IconThemeData(size: 40),
      selectedItemColor: AppColors().hintColor,
      unselectedItemColor: AppColors().hintColor,
      selectedLabelStyle: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
    scaffoldBackgroundColor: AppColors().backgroundColor,
  );
}
