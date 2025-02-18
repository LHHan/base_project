import 'package:flutter/material.dart';

class AppColors {
  static final AppColors _singleton = AppColors._internal();

  factory AppColors() {
    return _singleton;
  }

  AppColors._internal();

  Color seedColorLight = Colors.red;
  Color seedColorDark = Colors.deepOrange;

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
