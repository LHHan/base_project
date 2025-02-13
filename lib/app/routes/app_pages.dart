import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/isolate/bindings/isolate_binding.dart';
import '../modules/isolate/views/isolate_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/bindings/setting_language_binding.dart';
import '../modules/setting/views/setting_languages_view.dart';
import '../modules/setting/views/setting_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SETTING;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_LANGUAGES,
      page: () => const SettingLanguagesView(),
      binding: SettingLanguagesBinding(),
    ),
    GetPage(
      name: _Paths.ISOLATE,
      page: () => const IsolateView(),
      binding: IsolateBinding(),
    ),
  ];
}
