import 'package:base_project_getx/app/core/utils/app_theme.dart';
import 'package:base_project_getx/app/core/utils/app_enum.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_log.dart';
import '../../../services/localization_service.dart';

class HomeController extends GetxController {
  /// #region define variables
  bool isDark = Get.isDarkMode;
  String selectedLocale = LocalizationService.locale.languageCode;

  /// #region define functions
  void onChangeAppTheme() {
    isDark
        ? Get.changeTheme(AppTheme().light)
        : Get.changeTheme(AppTheme().dark);
    isDark = !isDark;
    update(['changeAppTheme']);
    logger.i('Changed App Theme to \'${isDark ? 'dark' : 'light'}\'');
  }

  void onChangeAppLocale() {
    selectedLocale = selectedLocale == LocaleCode.en.name
        ? LocaleCode.vi.name
        : LocaleCode.en.name;

    LocalizationService.changeLocale(selectedLocale);
    update(['changeAppLocale']);
    logger.i('Changed App Locale to $selectedLocale');
  }
}
