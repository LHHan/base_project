import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  var currentPage = 0.obs;

  final List<OnboardingPage> pages = const [
    OnboardingPage(
      title: 'Welcome',
      description: 'Discover a world of amazing products and connect with people around you.',
      icon: Icons.waving_hand_rounded,
      color: Color(0xFF6C63FF),
    ),
    OnboardingPage(
      title: 'Stay Connected',
      description: 'Chat with friends, receive notifications and never miss an update.',
      icon: Icons.chat_bubble_rounded,
      color: Color(0xFF43A047),
    ),
    OnboardingPage(
      title: "Let's Get Started",
      description: 'Your experience begins now. Explore, connect and enjoy everything the app has to offer.',
      icon: Icons.rocket_launch_rounded,
      color: Color(0xFFE53935),
    ),
  ];

  bool get isLastPage => currentPage.value == pages.length - 1;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (isLastPage) {
      goToHome();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() => goToHome();

  void goToHome() => Get.offAllNamed(Routes.HOME);
}
