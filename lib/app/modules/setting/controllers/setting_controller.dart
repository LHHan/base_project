import 'package:base_project_getx/app/data/models/languages_model.dart';
import 'package:base_project_getx/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_log.dart';
import '../../../core/utils/app_theme.dart';
import '../../../services/localization_service.dart';
import '../../home/controllers/home_controller.dart';

class SettingController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();

  /// #region define variables
  var isDark = Get.isDarkMode.obs;
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

  /// #region define functions
  void onPressedLanguages() {
    Get.toNamed(
      Routes.SETTING_LANGUAGES,
      arguments: {
        Languages().localKey: LocalizationService.locale.languageCode
      },
    );
  }

  void onPressedBtnIsolate() {
    Get.toNamed(Routes.ISOLATE);
  }

  void onChangeAppTheme() {
    isDark.value = !isDark.value;

    isDark.value
        ? Get.changeTheme(AppTheme().dark)
        : Get.changeTheme(AppTheme().light);

    logger.i('Changed App Theme to \'${isDark.value ? 'dark' : 'light'}\'');
  }

  void _onScroll() {
    final position = scrollController.position;

    if (homeController.currentIndex.value == 3) {
      if (!_onTop && position.extentAfter > 0) {
        _onTop = true;
      } else if (_onTop && position.extentBefore > 0) {
        _onTop = false;
      }

      homeController.updateUIBottomNavBar(
          isBottom: !_onTop && position.extentAfter < 20);
    }
  }
}
