import 'package:base_project_getx/app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  HomeController({required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;

  var currentIndex = 0.obs;
  final PageController pageController = PageController();
  var isScrolledToBottomInSettingPage = false.obs;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    if (index != 3 && isScrolledToBottomInSettingPage.value) {
      updateUIBottomNavBar(isBottom: false);
    }
  }

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
}
