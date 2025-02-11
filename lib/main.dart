import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/utils/app_config.dart';
import 'app/core/utils/app_log.dart';
import 'app/core/utils/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/services/app_binding.dart';
import 'app/services/auth_service.dart';
import 'app/services/localization_service.dart';

Future<void> main() async {
  /// Start services later
  WidgetsFlutterBinding.ensureInitialized();
  await _initialService();

  /// Force portrait mode
  await SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp]);

  /// Load environment and set app config
  await _loadEnvironment();

  /// Run Application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Init dynamic size
    /// https://pub.dev/packages/flutter_screenutil
    ///    ScreenUtil().pixelRatio       //Device pixel density
    ///    ScreenUtil().screenWidth   (sdk>=2.6 : 1.sw)    //Device width
    ///    ScreenUtil().screenHeight  (sdk>=2.6 : 1.sh)    //Device height
    ///    ScreenUtil().bottomBarHeight  //Bottom safe zone distance, suitable for buttons with full screen
    ///    ScreenUtil().statusBarHeight  //Status bar height , Notch will be higher Unit px
    ///    ScreenUtil().textScaleFactor  //System font scaling factor
    ///
    ///    ScreenUtil().scaleWidth //Ratio of actual width dp to design draft px
    ///    ScreenUtil().scaleHeight //Ratio of actual height dp to design draft px
    ///
    ///    0.2.sw  //0.2 times the screen width
    ///    0.5.sh  //50% of screen height
    /// Set the fit size (fill in the screen size of the device in the design)
    /// https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
    ///    iPhone 6, 6s, 7, 8, SE (2st Gen)  => 4.7": 375 x 667 (points)
    ///    iPhone 6+, 6s+, 7+, 8+            => 5.5": 414 x 736 (points)
    ///    iPhone 11Pro, X, Xs               => 5.8": 375 x 812 (points)
    ///    iPhone 11, Xr                     => 6.1": 414 × 896 (points)
    ///    iPhone 11Pro Max, Xs Max          => 6.5": 414 x 896 (points)
    ///    iPhone 12 mini                    => 5.4": 375 x 812 (points)
    ///    iPhone 12, 12 Pro                 => 6.1": 390 x 844 (points)
    ///    iPhone 12 Pro Max                 => 6.7": 428 x 926 (points)
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => GetMaterialApp(
        title: 'Application',
        debugShowCheckedModeBanner: false,
        initialRoute: AppPages.INITIAL,
        initialBinding: AppBinding(),
        getPages: AppPages.routes,
        theme: AppTheme().light,
        darkTheme: AppTheme().dark,
        themeMode: ThemeMode.system,
        locale: LocalizationService.locale,
        fallbackLocale: LocalizationService.fallbackLocale,
        translations: LocalizationService(),
        home: __,
      ),
    );
  }
}

Future<void> _loadEnvironment() async {
  /// Get Flavor value from native via method channel
  String? flavor =
      await const MethodChannel('flavor').invokeMethod<String>('getFlavor');

  if (flavor == 'dev') {
    AppConfig(env: Env.dev(), theme: AppTheme());
    logger.i('Started with flavor $flavor!');
  } else if (flavor == 'prod') {
    AppConfig(env: Env.prod(), theme: AppTheme());
    logger.i('Started with flavor $flavor!');
  } else {
    logger.e('Unknown flavor: $flavor');
    throw Exception("Unknown flavor: $flavor");
  }
}

Future<void> _initialService() async {
  /// GetStorage service
  await GetStorage.init();

  /// Authentication service
  Get.put(AuthService());
}
