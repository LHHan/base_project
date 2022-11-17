import 'package:flutter/material.dart';

class AppColors {
  static final AppColors _singleton = AppColors._internal();

  factory AppColors() {
    return _singleton;
  }

  AppColors._internal();

  Color colorBackground = const Color(0xFFFAFAFA);
  Color colorMainText = const Color(0xFF202020);
  Color colorHintText = const Color(0xFFD5D5D6);
}
