import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WSettingItem extends StatelessWidget {
  const WSettingItem({
    Key? key,
    required this.title,
    this.subTitle,
    this.leading,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final String? subTitle;
  final Widget? leading;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      title: Text(
        title,
        style: Get.textTheme.tsTitle,
      ),
      leading: leading,
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
      ),
      subtitle: subTitle != null
          ? Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0).w,
              child: Text(
                subTitle ?? '',
                style: Get.textTheme.tsSubTitle,
              ),
            )
          : null,
    );
  }
}
