import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../widgets/p_appbar_transparency.dart';
import '../../../widgets/w_bottom_nav_bar_dynamic.dart';
import '../../../widgets/w_keep_alive.dart';
import '../../chat/views/chat_view.dart';
import '../../feed/views/feed_view.dart';
import '../../notifications/views/notifications_view.dart';
import '../../setting/views/setting_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PAppbarTransparency(
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: controller.pageController,
              onPageChanged: (index) => controller.onPageChanged(index),
              children: [
                WKeepAlive(child: FeedView()),
                WKeepAlive(child: ChatView()),
                WKeepAlive(child: NotificationsView()),
                WKeepAlive(child: SettingView()),
              ],
            ),

            // Floating Bottom Navigation Bar
            Positioned(
              bottom: 16.h,
              left: 20.w,
              right: 20.w,
              child: Obx(
                () => WBottomNavBarDynamic(
                  currentIndex: controller.currentIndex.value,
                  onTabSelected: controller.onTabSelected,
                  showLogout: controller.isScrolledToBottomInSettingPage.value,
                  onLogoutPressed: controller.onPressedBtnLogout,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
