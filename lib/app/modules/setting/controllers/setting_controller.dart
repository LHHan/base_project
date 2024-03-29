import 'package:base_project_getx/app/data/models/languages_model.dart';
import 'package:base_project_getx/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_log.dart';
import '../../../core/utils/app_theme.dart';
import '../../../services/localization_service.dart';

class SettingController extends GetxController {
  /// #region define variables
  bool isDark = Get.isDarkMode;

  /// #region define functions
  void onPressedLanguages() {
    Get.toNamed(
      Routes.SETTING_LANGUAGES,
      arguments: {
        Languages().localKey: LocalizationService.locale.languageCode
      },
    );
  }

  void onChangeAppTheme() {
    isDark
        ? Get.changeTheme(AppTheme().light)
        : Get.changeTheme(AppTheme().dark);
    isDark = !isDark;
    logger.i('Changed App Theme to \'${isDark ? 'dark' : 'light'}\'');
  }
}
