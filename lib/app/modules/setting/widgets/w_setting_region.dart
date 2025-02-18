import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WSettingRegion extends StatelessWidget {
  const WSettingRegion({
    Key? key,
    this.label,
    this.children,
  }) : super(key: key);

  final String? label;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// Label
        Text(
          label ?? '',
          style: Get.textTheme.tsLabel,
        ),

        10.verticalSpace,

        Card(
          elevation: 2,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children ?? [],
          ),
        ),
      ],
    );
  }
}
