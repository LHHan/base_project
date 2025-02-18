import 'package:base_project_getx/app/core/utils/app_extension.dart';
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
        color: Get.theme.colorScheme.secondary,
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
            backgroundColor:
                Get.theme.colorScheme.primary.withValues(alpha: 0.4),
            child: CircleAvatar(
              maxRadius: 55.r,
              backgroundColor:
                  Get.theme.colorScheme.primary.withValues(alpha: 0.5),
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
                  style: Get.textTheme.tsBody.copyWith(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                /// Email
                Text(
                  mail,
                  style: Get.textTheme.tsBody,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
