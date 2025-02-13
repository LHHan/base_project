import 'package:base_project_getx/app/data/models/languages_model.dart';
import 'package:base_project_getx/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_log.dart';
import '../../../core/utils/app_theme.dart';
import '../../../services/localization_service.dart';

class SettingController extends GetxController {
  /// #region define variables
  var isDark = Get.isDarkMode.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
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

    update(['idSettingPage']);

    logger.i('Changed App Theme to \'${isDark.value ? 'dark' : 'light'}\'');
  }
}
