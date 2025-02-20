import 'dart:core';

class AppConstant {
  static final AppConstant _singleton = AppConstant._internal();

  factory AppConstant() {
    return _singleton;
  }

  AppConstant._internal();

  int get kBottomNavigationBarHeight => 100;
}
