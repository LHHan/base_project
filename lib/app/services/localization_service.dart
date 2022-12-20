import 'dart:ui';

import 'package:get/get.dart';

import '../core/languages/en_us.dart';
import '../core/languages/vi_vn.dart';
import '../core/utils/app_enum.dart';

class LocalizationService extends Translations {
  /// Get locale when open app
  /// Can be get from a default language, or device language, or cached language
  static final locale = _getLocaleFromLanguage();

  /// fallbackLocale is the default language
  /// if the set language is not in the list of languages supported by the app
  static const fallbackLocale = Locale('en', 'US');

  /// List of supported Locales
  static final locales = [
    const Locale('en', 'US'),
    const Locale('vi', 'VN'),
  ];

  /// Change locale function
  /// Call it when you want to update locale for app regardless of system language
  static void changeLocale(String langCode) {
    final locale = _getLocaleFromLanguage(langCode: langCode);
    Get.updateLocale(locale);
  }

  /// Get locale from language function (private)
  /// Params: String? langCode
  static Locale _getLocaleFromLanguage({String? langCode}) {
    var lang = langCode ?? Get.deviceLocale?.languageCode;
    for (int i = 0; i < LocaleCode.values.length; i++) {
      if (lang == LocaleCode.values[i].name) return locales[i];
    }
    return Get.locale ?? fallbackLocale;
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en,
        'vi_VN': vi,
      };
}
