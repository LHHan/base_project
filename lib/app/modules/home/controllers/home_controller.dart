import 'package:base_project_getx/app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// ********
  /// #region define service, provider
  /// ********
  final _apiService = ApiService.defined;

  /// ********
  /// #region define variables
  /// ********
  var currentIndex = 0.obs;
  final PageController pageController = PageController();

  var isScrolledToBottomInSettingPage = false.obs;

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

  /// When swiping PageView, update currentIndex
  void onPageChanged(int index) {
    currentIndex.value = index;

    if (index != 3 && isScrolledToBottomInSettingPage.value) {
      updateUIBottomNavBar(isBottom: false);
    }
  }

  /// When clicking on BottomNavigation, switch to the corresponding page
  void onTabSelected(int index) {
    if (index != currentIndex.value) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
      currentIndex.value = index;
    }
  }

  void onPressedBtnLogout({bool isBottom = false}) {
    _apiService.logout();
  }

  void updateUIBottomNavBar({bool isBottom = false}) {
    isScrolledToBottomInSettingPage.value = isBottom;
  }

  /// ********
  /// #region define private functions
  /// ********
}
