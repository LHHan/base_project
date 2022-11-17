import 'package:base_project_getx/app/core/values/app_asset.dart';
import 'package:base_project_getx/app/core/values/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  void onPressed() {
    var s1 = AppAssets;
    var s2 = AppAssets;
    var c1 = AppColors();
    var c2 = AppColors();
    print('kDebugMode');
    // hàm identical giúp ta so sánh cùng địa chỉ hay ko?. Giống toán tử === bên Kotlin
    if (kDebugMode) {
      print(identical(s1, s2));
      print(identical(c1, c2));
    } // in ra: true
  }
}
