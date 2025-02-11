import 'package:base_project_getx/app/core/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WSettingAccountInfo extends StatelessWidget {
  const WSettingAccountInfo({
    Key? key,
    required this.avatar,
    required this.name,
    required this.mail,
  }) : super(key: key);

  final String avatar;
  final String name;
  final String mail;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      constraints: BoxConstraints(
        minHeight: 150.h,
      ),
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
      child: Row(
        children: [
          /// Avatar
          CircleAvatar(
            maxRadius: 70.r,
            backgroundColor: Colors.orange.withValues(alpha: 0.4),
            child: CircleAvatar(
              maxRadius: 55.r,
              backgroundColor: Colors.orange.withValues(alpha: 0.5),
              child: CircleAvatar(
                maxRadius: 45.r,
                backgroundColor: Colors.white54,
                child: ClipOval(
                  child: Image.asset(
                    avatar,
                    width: Get.width,
                    height: Get.height,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          20.horizontalSpace,

          /// Full name and Email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Full name
                Text(
                  name,
                  style: AppStyles().semiBoldTextStyle(26.sp),
                ),

                /// Email
                Text(
                  mail,
                  style: AppStyles().normalTextStyle(16.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
