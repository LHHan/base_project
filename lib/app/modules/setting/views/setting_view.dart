import 'package:base_project_getx/app/core/utils/app_style.dart';
import 'package:base_project_getx/app/modules/setting/widgets/w_setting_account_info.dart';
import 'package:base_project_getx/app/widgets/p_appbar_transparency.dart';
import 'package:base_project_getx/app/widgets/w_button_rounded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../core/utils/app_asset.dart';
import '../controllers/setting_controller.dart';
import '../widgets/w_setting_item.dart';
import '../widgets/w_setting_region.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({Key? key}) : super(key: key);

  static final kPadding = const EdgeInsets.fromLTRB(10, 0, 10, 0).w;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        id: 'idSettingPage',
        init: controller,
        builder: (context) {
          return PAppBarTransparency(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// Page's name
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0).w,
                    child: Text(
                      'screenNameSettings'.tr,
                      style: AppStyles().mediumTextStyle(36.sp),
                    ),
                  ),

                  20.verticalSpace,

                  /// Account info
                  Padding(
                    padding: kPadding,
                    child: WSettingAccountInfo(
                      avatar: AppAssets().imDog,
                      name: 'Le Hoang Han',
                      mail: 'hoanghan.le.95@gmail.com',
                    ),
                  ),

                  25.verticalSpace,

                  /// General setting
                  Padding(
                    padding: kPadding,
                    child: WSettingRegion(
                      label: 'General',
                      children: [
                        /// Languages
                        WSettingItem(
                          title: "labelLanguages".tr,
                          onPressed: controller.onPressedLanguages,
                          subTitle: "English",
                          leading: const Icon(Icons.language),
                        ),

                        const Divider(height: 0),

                        /// Themes
                        WSettingItem(
                          title: 'labelTheme'.tr,
                          onPressed: controller.onChangeAppTheme,
                          subTitle: "Light",
                          leading: const Icon(Icons.lightbulb),
                        ),
                      ],
                    ),
                  ),

                  25.verticalSpace,

                  /// Account setting
                  Padding(
                    padding: kPadding,
                    child: WSettingRegion(
                      label: "labelAccount".tr,
                      children: [
                        /// Change password
                        WSettingItem(
                          title: "labelChangePassword".tr,
                          onPressed: () {},
                          leading:
                              const Icon(Icons.admin_panel_settings_rounded),
                        ),
                      ],
                    ),
                  ),

                  50.verticalSpace,

                  /// Logout
                  Container(
                    padding: kPadding,
                    constraints: const BoxConstraints(minHeight: 46).h,
                    child: WButtonRounded(
                      onPressed: () {},
                      background: const ColorScheme.light().error,
                      child: Text(
                        'btnLogout'.tr,
                        style: AppStyles().semiBoldTextStyle(20.sp),
                      ),
                    ),
                  ),

                  30.verticalSpace,
                ],
              ),
            ),
          );
        });
  }
}
