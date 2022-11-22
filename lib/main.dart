import 'package:base_project_getx/app/core/utils/app_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/core/themes/app_theme.dart';
import 'app/core/utils/app_config.dart';
import 'app/routes/app_pages.dart';
import 'app/services/localization_service.dart';

Future<void> main() async {
  /// Start services later
  WidgetsFlutterBinding.ensureInitialized();

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
    return GetMaterialApp(
      title: 'Application',
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme().light,
      darkTheme: AppTheme().dark,
      themeMode: ThemeMode.system,
      locale: LocalizationService.locale,
      fallbackLocale: LocalizationService.fallbackLocale,
      translations: LocalizationService(),
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
