import 'package:flutter/material.dart';

class AppColors {
  static final AppColors _singleton = AppColors._internal();

  factory AppColors() {
    return _singleton;
  }

  AppColors._internal();

  Color colorPrimary = const Color(0xFF477256);
  Color colorSecondary = const Color(0xFF988F22);
  Color colorError = const Color(0xFFB00020);
  Color colorBackground = const Color(0xFFFDFBF3);
}
