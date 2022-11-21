import 'package:base_project_getx/app/core/themes/app_theme.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_log.dart';

class HomeController extends GetxController {
  /// #Define variables
  bool isDark = Get.isDarkMode;
  var testText = 'cc'.obs;

  /// #Define functions
  void onChangeAppTheme() {
    isDark
        ? Get.changeTheme(AppTheme().light)
        : Get.changeTheme(AppTheme().dark);
    isDark = !isDark;
    update(['ChangeThemeMode']);
  }
}
