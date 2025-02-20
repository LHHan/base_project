import 'package:base_project_getx/app/core/utils/app_asset.dart';
import 'package:base_project_getx/app/widgets/w_dashed_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const WBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20).r,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10).r,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(icon: Icons.home, index: 0),
          _navItem(icon: Icons.chat_bubble, index: 1),
          _navItem(icon: Icons.notifications, index: 2),
          _navItem(icon: Icons.person, index: 3, isAvatar: true),
        ],
      ),
    );
  }

  Widget _navItem(
      {required IconData icon, required int index, bool isAvatar = false}) {
    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: WDashedBox(
          color: isSelected ? Colors.blue : Colors.grey.shade400,
          dashWidth: 6.r,
          dashSpace: 4.r,
          strokeWidth: 2.r,
          borderRadius: 14.r,
          child: AnimatedScale(
            scale: isSelected ? 1.2 : 1.0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isAvatar
                ? CircleAvatar(
                    radius: 14.r,
                    backgroundImage: AssetImage(AppAssets().imDog),
                  )
                : Icon(
                    icon,
                    size: 28.r,
                    color: isSelected ? Colors.blue : Colors.grey.shade500,
                  ),
          ),
        ),
      ),
    );
  }
}
