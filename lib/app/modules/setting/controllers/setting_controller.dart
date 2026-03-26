import 'package:base_project_getx/app/data/models/languages_model.dart';
import 'package:base_project_getx/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_log.dart';
import '../../../core/utils/app_theme.dart';
import '../../../services/localization_service.dart';
import '../../home/controllers/home_controller.dart';

class SettingController extends GetxController {
  SettingController({required HomeController homeController})
      : _homeController = homeController;

  final HomeController _homeController;

  // Appearance
  var isDark = Get.isDarkMode.obs;

  // Notifications
  var isPushNotificationsEnabled = true.obs;
  var isSoundsEnabled = true.obs;
  var isVibrationEnabled = true.obs;

  // Storage
  var isWifiOnlyDownload = false.obs;

  var _onTop = true;
  final ScrollController scrollController = ScrollController();

  @override
  Future<void> onInit() async {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  @override
  Future<void> onClose() async {
    scrollController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // General
  // ---------------------------------------------------------------------------

  void onPressedLanguages() {
    Get.toNamed(
      Routes.SETTING_LANGUAGES,
      arguments: {
        Languages().localKey: LocalizationService.locale.languageCode,
      },
    );
  }

  void onChangeAppTheme() {
    isDark.value = !isDark.value;
    isDark.value
        ? Get.changeTheme(AppTheme().dark)
        : Get.changeTheme(AppTheme().light);
    logger.i('Changed App Theme to \'${isDark.value ? 'dark' : 'light'}\'');
  }

  // ---------------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------------

  void onTogglePushNotifications(bool value) =>
      isPushNotificationsEnabled.value = value;

  void onToggleSounds(bool value) => isSoundsEnabled.value = value;

  void onToggleVibration(bool value) => isVibrationEnabled.value = value;

  // ---------------------------------------------------------------------------
  // Account
  // ---------------------------------------------------------------------------

  void onPressedEditProfile() {
    // TODO: Navigate to edit profile screen
  }

  void onPressedChangePassword() {
    // TODO: Navigate to change password screen
  }

  void onPressedTwoStepVerification() {
    // TODO: Navigate to two-step verification screen
  }

  // ---------------------------------------------------------------------------
  // Storage
  // ---------------------------------------------------------------------------

  void onPressedClearCache() {
    Get.defaultDialog(
      title: 'Clear Cache',
      middleText: 'This will remove all cached data. Continue?',
      textConfirm: 'Clear',
      textCancel: 'Cancel',
      onConfirm: () {
        Get.back();
        // TODO: implement cache clearing
      },
    );
  }

  void onToggleWifiOnlyDownload(bool value) =>
      isWifiOnlyDownload.value = value;

  // ---------------------------------------------------------------------------
  // About
  // ---------------------------------------------------------------------------

  void onPressedRateApp() {
    // TODO: Open app store rating
  }

  void onPressedTermsOfService() {
    // TODO: Open terms of service
  }

  void onPressedPrivacyPolicy() {
    // TODO: Open privacy policy
  }

  void onPressedHelpAndSupport() {
    // TODO: Open help & support
  }

  // ---------------------------------------------------------------------------
  // Learning (demo)
  // ---------------------------------------------------------------------------

  void onPressedBtnIsolate() {
    Get.toNamed(Routes.ISOLATE);
  }

  // ---------------------------------------------------------------------------
  // Sign out
  // ---------------------------------------------------------------------------

  void onPressedSignOut() {
    Get.defaultDialog(
      title: 'labelSignOut'.tr,
      middleText: 'labelSignOutConfirm'.tr,
      textConfirm: 'labelSignOut'.tr,
      textCancel: 'labelCancel'.tr,
      confirmTextColor: Get.theme.colorScheme.onError,
      buttonColor: Get.theme.colorScheme.error,
      onConfirm: () {
        Get.back();
        // TODO: call auth service logout
      },
    );
  }

  // ---------------------------------------------------------------------------

  void _onScroll() {
    final position = scrollController.position;

    if (_homeController.currentIndex.value == 3) {
      if (!_onTop && position.extentAfter > 0) {
        _onTop = true;
      } else if (_onTop && position.extentBefore > 0) {
        _onTop = false;
      }

      _homeController.updateUIBottomNavBar(
          isBottom: !_onTop && position.extentAfter < 20);
    }
  }
}
