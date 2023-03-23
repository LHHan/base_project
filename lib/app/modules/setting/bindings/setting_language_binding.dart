import 'package:get/get.dart';

import '../controllers/setting_languages_controller.dart';

class SettingLanguagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingLanguagesController>(
      () => SettingLanguagesController(),
    );
  }
}
