import 'package:base_project_getx/app/widgets/p_appbar_transparency.dart';
import 'package:base_project_getx/app/widgets/w_bottom_nav_bar.dart';
import 'package:base_project_getx/app/widgets/w_keep_alive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../chat/views/chat_view.dart';
import '../../feed/views/feed_view.dart';
import '../../notifications/views/notifications_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PAppbarTransparency(
      child: Scaffold(
        body: PageView(
          controller: controller.pageController,
          children: [
            WKeepAlive(child: FeedView()),
            WKeepAlive(child: ChatView()),
            WKeepAlive(child: NotificationsView()),
            WKeepAlive(child: ProfileView()),
          ],
        ),
        bottomNavigationBar: Obx(
          () => WBottomNavBar(
            currentIndex: controller.currentIndex.value,
            onTabSelected: (index) => controller.onChangePageIndex(index),
          ),
        ),
      ),

      // child: CupertinoTabScaffold(
      //   tabBar: CupertinoTabBar(
      //     items: const [
      //       BottomNavigationBarItem(
      //           icon: Icon(CupertinoIcons.news), label: 'Feed'),
      //       BottomNavigationBarItem(
      //           icon: Icon(CupertinoIcons.chat_bubble), label: 'Chat'),
      //       BottomNavigationBarItem(
      //           icon: Icon(CupertinoIcons.bell), label: 'Notifications'),
      //       BottomNavigationBarItem(
      //           icon: Icon(CupertinoIcons.person), label: 'Profile'),
      //     ],
      //     onTap: (value) => controller.onChangeTabIndex(value),
      //   ),
      //   tabBuilder: (context, index) {
      //     return CupertinoTabView(
      //       builder: (context) => controller.screens[index],
      //     );
      //   },
      // ),
    );
  }
}
