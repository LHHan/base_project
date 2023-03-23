import 'package:base_project_getx/app/data/models/languages_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/utils/app_log.dart';
import '../../../services/localization_service.dart';

class SettingLanguagesController extends GetxController {
  /// #region define variables

  var dummyLanguages = [
    Languages(
      id: 1,
      langCode: 'vi',
      langName: 'Vietnamese',
      langFlag:
          'https://upload.wikimedia.org/wikipedia/commons/2/21/Flag_of_Vietnam.svg',
    ),
    Languages(
      id: 2,
      langCode: 'en',
      langName: 'English',
      langFlag:
          'https://upload.wikimedia.org/wikipedia/en/a/a4/Flag_of_the_United_States.svg',
    ),
    Languages(
      id: 3,
      langCode: 'ja',
      langName: 'Japanese',
      langFlag:
          'https://upload.wikimedia.org/wikipedia/commons/9/9e/Flag_of_Japan.svg',
    ),
    Languages(
      id: 4,
      langCode: 'fr',
      langName: 'France',
      langFlag:
          'https://upload.wikimedia.org/wikipedia/commons/1/18/Flag_of_France_%28lighter_variant%29.svg',
    ),
    Languages(
      id: 5,
      langCode: 'ru',
      langName: 'Russia',
      langFlag:
          'https://upload.wikimedia.org/wikipedia/en/f/f3/Flag_of_Russia.svg',
    ),
    Languages(
      id: 6,
      langCode: 'ko',
      langName: 'Korea',
      langFlag:
          'https://upload.wikimedia.org/wikipedia/commons/2/28/Flag_of_South_Korea_%281945–1948%29.svg',
    ),
    Languages(
      id: 7,
      langCode: 'es',
      langName: 'Spanish',
      langFlag:
          'https://upload.wikimedia.org/wikipedia/commons/8/89/Bandera_de_España.svg',
    ),
    Languages(
      id: 8,
      langCode: 'pt',
      langName: 'Portugal',
      langFlag:
          'https://upload.wikimedia.org/wikipedia/commons/5/5c/Flag_of_Portugal.svg',
    ),
  ];

  var selectedLang = Languages().obs;

  @override
  void onReady() async {
    super.onReady();

    selectedLang.value = dummyLanguages[dummyLanguages.indexWhere((element) =>
        element.langCode == GetStorage().read(Languages().localKey))];
    update(['idLanguagesItem_${dummyLanguages.indexOf(selectedLang.value)}']);
  }

  /// #region define functions
  void onSelectLanguage({required int indexLang}) {
    var oldIndexLang = dummyLanguages.indexOf(selectedLang.value);
    selectedLang.value = dummyLanguages[indexLang];
    update(['idLanguagesItem_$indexLang', 'idLanguagesItem_$oldIndexLang']);
  }

  void onPressedOKButton() {
    GetStorage()
        .write(Languages().localKey, selectedLang.value.langCode ?? 'en');
    LocalizationService.changeLocale(selectedLang.value.langCode ?? 'en');
    logger.i('Changed App Locale to ${selectedLang.value.langCode}');

    Get.back();
  }
}
