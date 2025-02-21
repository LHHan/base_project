import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:base_project_getx/app/modules/setting/widgets/w_setting_account_info.dart';
import 'package:base_project_getx/app/widgets/p_appbar_transparency.dart';
import 'package:base_project_getx/app/widgets/w_button_rounded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_asset.dart';
import '../../../core/utils/app_const.dart';
import '../controllers/setting_controller.dart';
import '../widgets/w_setting_item.dart';
import '../widgets/w_setting_region.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  static final kPadding = const EdgeInsets.fromLTRB(10, 0, 10, 0).w;

  @override
  Widget build(BuildContext context) {
    return PAppbarTransparency(
      body: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: AppConstant().kBottomNavigationBarHeight.h),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Page's name
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0).w,
                child: Text(
                  'screenNameSettings'.tr,
                  style: Get.textTheme.tsPageName,
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
                      subTitle: "labelCurrentLanguages".tr,
                      leading: const Icon(Icons.language),
                    ),

                    const Divider(height: 0),

                    /// Themes
                    WSettingItem(
                      title: 'labelTheme'.tr,
                      onPressed: controller.onChangeAppTheme,
                      subTitle: controller.isDark.value ? "Dark" : "Light",
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
                      leading: const Icon(Icons.admin_panel_settings_rounded),
                    ),
                  ],
                ),
              ),

              25.verticalSpace,

              Padding(
                padding: kPadding,
                child: WSettingRegion(
                  label: "labelLearning".tr,
                  children: [
                    /// Learning Isolate
                    WSettingItem(
                      title: "labelIsolate".tr,
                      onPressed: controller.onPressedBtnIsolate,
                      leading: const Icon(Icons.multiple_stop),
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
                  background: Get.theme.colorScheme.error,
                  child: Text(
                    'btnLogout'.tr,
                    style: Get.textTheme.tsButton,
                  ),
                ),
              ),

              30.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
