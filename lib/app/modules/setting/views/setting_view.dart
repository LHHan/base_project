import 'package:base_project_getx/app/core/utils/app_asset.dart';
import 'package:base_project_getx/app/core/utils/app_const.dart';
import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:base_project_getx/app/modules/setting/widgets/w_setting_account_info.dart';
import 'package:base_project_getx/app/modules/setting/widgets/w_setting_item.dart';
import 'package:base_project_getx/app/modules/setting/widgets/w_setting_region.dart';
import 'package:base_project_getx/app/modules/setting/widgets/w_setting_toggle_item.dart';
import 'package:base_project_getx/app/widgets/p_appbar_transparency.dart';
import 'package:base_project_getx/app/widgets/w_frosted_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  static final _kContentPadding = EdgeInsets.symmetric(horizontal: 10.w);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final appBarHeight = topPadding + kToolbarHeight;

    return PAppbarTransparency(
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              controller: controller.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: appBarHeight)),

                // Large title + account info
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'screenNameSettings'.tr,
                          style: Get.textTheme.tsPageName,
                        ),
                        SizedBox(height: 16.h),
                        WSettingAccountInfo(
                          avatar: AppAssets().imDog,
                          name: 'Le Hoang Han',
                          mail: 'hoanghan.le.95@gmail.com',
                        ),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    _kContentPadding.horizontal / 2,
                    4.h,
                    _kContentPadding.horizontal / 2,
                    AppConstant().kBottomNavigationBarHeight.h + 24.h,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // -------------------------------------------------------
                      // General
                      // -------------------------------------------------------
                      WSettingRegion(
                        label: 'General',
                        children: [
                          WSettingItem(
                            title: "labelLanguages".tr,
                            onPressed: controller.onPressedLanguages,
                            subTitle: "labelCurrentLanguages".tr,
                            leading: const Icon(Icons.language_rounded),
                          ),
                          const Divider(height: 0),
                          Obx(() => WSettingItem(
                                title: 'labelTheme'.tr,
                                onPressed: controller.onChangeAppTheme,
                                subTitle: controller.isDark.value
                                    ? 'Dark'
                                    : 'Light',
                                leading: Icon(controller.isDark.value
                                    ? Icons.dark_mode_rounded
                                    : Icons.light_mode_rounded),
                              )),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // -------------------------------------------------------
                      // Notifications
                      // -------------------------------------------------------
                      WSettingRegion(
                        label: 'labelNotifications'.tr,
                        children: [
                          Obx(() => WSettingToggleItem(
                                title: 'labelPushNotifications'.tr,
                                leading: const Icon(
                                    Icons.notifications_rounded),
                                value: controller
                                    .isPushNotificationsEnabled.value,
                                onChanged:
                                    controller.onTogglePushNotifications,
                              )),
                          const Divider(height: 0),
                          Obx(() => WSettingToggleItem(
                                title: 'labelSounds'.tr,
                                leading:
                                    const Icon(Icons.volume_up_rounded),
                                value: controller.isSoundsEnabled.value,
                                onChanged: controller.onToggleSounds,
                              )),
                          const Divider(height: 0),
                          Obx(() => WSettingToggleItem(
                                title: 'labelVibration'.tr,
                                leading:
                                    const Icon(Icons.vibration_rounded),
                                value: controller.isVibrationEnabled.value,
                                onChanged: controller.onToggleVibration,
                              )),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // -------------------------------------------------------
                      // Account
                      // -------------------------------------------------------
                      WSettingRegion(
                        label: "labelAccount".tr,
                        children: [
                          WSettingItem(
                            title: 'labelEditProfile'.tr,
                            onPressed: controller.onPressedEditProfile,
                            leading: const Icon(Icons.person_rounded),
                          ),
                          const Divider(height: 0),
                          WSettingItem(
                            title: "labelChangePassword".tr,
                            onPressed: controller.onPressedChangePassword,
                            leading: const Icon(
                                Icons.lock_outline_rounded),
                          ),
                          const Divider(height: 0),
                          WSettingItem(
                            title: 'labelTwoStepVerification'.tr,
                            onPressed:
                                controller.onPressedTwoStepVerification,
                            leading: const Icon(
                                Icons.verified_user_rounded),
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // -------------------------------------------------------
                      // Storage & Data
                      // -------------------------------------------------------
                      WSettingRegion(
                        label: 'labelStorageData'.tr,
                        children: [
                          Obx(() => WSettingToggleItem(
                                title: 'labelWifiOnlyDownload'.tr,
                                subTitle: 'labelWifiOnlyDownloadSub'.tr,
                                leading: const Icon(Icons.wifi_rounded),
                                value:
                                    controller.isWifiOnlyDownload.value,
                                onChanged:
                                    controller.onToggleWifiOnlyDownload,
                              )),
                          const Divider(height: 0),
                          WSettingItem(
                            title: 'labelClearCache'.tr,
                            onPressed: controller.onPressedClearCache,
                            leading: const Icon(
                                Icons.cleaning_services_rounded),
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // -------------------------------------------------------
                      // About
                      // -------------------------------------------------------
                      WSettingRegion(
                        label: 'labelAbout'.tr,
                        children: [
                          WSettingItem(
                            title: 'labelHelpSupport'.tr,
                            onPressed: controller.onPressedHelpAndSupport,
                            leading:
                                const Icon(Icons.help_outline_rounded),
                          ),
                          const Divider(height: 0),
                          WSettingItem(
                            title: 'labelRateApp'.tr,
                            onPressed: controller.onPressedRateApp,
                            leading:
                                const Icon(Icons.star_outline_rounded),
                          ),
                          const Divider(height: 0),
                          WSettingItem(
                            title: 'labelTermsOfService'.tr,
                            onPressed: controller.onPressedTermsOfService,
                            leading: const Icon(
                                Icons.description_outlined),
                          ),
                          const Divider(height: 0),
                          WSettingItem(
                            title: 'labelPrivacyPolicy'.tr,
                            onPressed: controller.onPressedPrivacyPolicy,
                            leading:
                                const Icon(Icons.privacy_tip_outlined),
                          ),
                          const Divider(height: 0),
                          ListTile(
                            leading: const Icon(Icons.info_outline_rounded),
                            title: Text('labelAppVersion'.tr,
                                style: Get.textTheme.tsTitle),
                            trailing: Text(
                              '1.0.0',
                              style: Get.textTheme.tsSubTitle,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // -------------------------------------------------------
                      // Learning (demo)
                      // -------------------------------------------------------
                      WSettingRegion(
                        label: "labelLearning".tr,
                        children: [
                          WSettingItem(
                            title: "labelIsolate".tr,
                            onPressed: controller.onPressedBtnIsolate,
                            leading:
                                const Icon(Icons.multiple_stop_rounded),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),
                    ]),
                  ),
                ),
              ],
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: WFrostedAppBar(
                topPadding: topPadding,
                scrollController: controller.scrollController,
                title: 'screenNameSettings'.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
