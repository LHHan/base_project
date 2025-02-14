import 'package:flutter/material.dart';

class AppColors {
  static final AppColors _singleton = AppColors._internal();

  factory AppColors() {
    return _singleton;
  }

  AppColors._internal();

  Color colorPrimary = const Color(0xFF6200EE);
  Color colorSecondary = const Color(0xFF03DAC6);
  Color colorError = const Color(0xFFB00020);
  Color colorBackground = const Color(0xFFFDFBF3);

  Color textColor = const Color(0xFFD0D7E1);
  Color hintColor = const Color(0xFF717578);
  Color backgroundColor = const Color(0xff343941);
  Color cardColor = const Color(0xff4D565F);
  Color trackColor = const Color(0xff2C3037);
  Color selectedColor = const Color(0xffE3D0B2);

  List<Color> cardColors = [
    const Color(0xff60656D),
    const Color(0xff4D565F),
    const Color(0xff464D57),
  ];
  List<Color> dimmedLightColors = [
    const Color(0xff505863),
    const Color(0xff424a53),
    const Color(0xff343941),
  ];
}
