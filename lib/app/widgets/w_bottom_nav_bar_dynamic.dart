import 'package:base_project_getx/app/core/utils/app_asset.dart';
import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:base_project_getx/app/widgets/w_dashed_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WBottomNavBarDynamic extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final bool showLogout;
  final VoidCallback onLogoutPressed;

  const WBottomNavBarDynamic({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    this.showLogout = false,
    required this.onLogoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(horizontal: 20).r,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15).r,
        decoration: BoxDecoration(
          color: showLogout
              ? Get.theme.colorScheme.error
              : const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(50.r),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withValues(alpha: 0.4),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale:
                      Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                  child: child,
                ),
              );
            },
            child: showLogout ? _buildLogout() : _buildNavItems(),
          ),
        ),
      ),
    );
  }

  /// Widget chứa 4 item trong bottom navigation
  Widget _buildNavItems() {
    return Row(
      key: const ValueKey("navItems"),
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _navItem(icon: Icons.home, index: 0),
        _navItem(icon: Icons.chat_bubble, index: 1),
        _navItem(icon: Icons.notifications, index: 2),
        _navItem(icon: Icons.person, index: 3, isAvatar: true),
      ],
    );
  }

  /// Logout button widget
  Widget _buildLogout() {
    return Row(
      key: const ValueKey("logoutButton"),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// Icon
        Icon(Icons.logout, color: Colors.white, size: 28.r),

        10.horizontalSpace,

        /// Text
        Text(
          "btnLogout".tr,
          style: Get.textTheme.tsButton,
        ),
      ],
    );
  }

  /// Item trong Bottom Nav Bar
  Widget _navItem(
      {required IconData icon, required int index, bool isAvatar = false}) {
    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(2.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFA020F0).withValues(alpha: 0.4),
                    blurRadius: 30,
                    spreadRadius: 4,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [],
        ),
        child: WDashedBox(
          color: isSelected ? const Color(0xFFA020F0) : const Color(0xFFB0BEC5),
          dashWidth: 6.r,
          dashSpace: 4.r,
          strokeWidth: 2.r,
          borderRadius: 14.r,
          child: AnimatedScale(
            scale: isSelected ? 1.25 : 1.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: CircleAvatar(
              radius: isSelected ? 16.r : 14.r,
              backgroundImage: isAvatar ? AssetImage(AppAssets().imDog) : null,
              backgroundColor: Colors.transparent,
              child: isAvatar
                  ? null
                  : Icon(
                      icon,
                      size: 28.r,
                      color: const Color(0xFFC0C0C0),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
