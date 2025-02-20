import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// ********
  /// #region define service, provider
  /// ********

  /// ********
  /// #region define variables
  /// ********
  var currentIndex = 0.obs;
  final PageController pageController = PageController();

  /// ********
  /// #region implement app lifecycle
  /// ********
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// ********
  /// #region define public functions
  /// ********
  void onChangePageIndex(int index) {
    // update currentIndex
    currentIndex.value = index;

    // animate to page
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// ********
  /// #region define private functions
  /// ********
}
