import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/utils/app_config.dart';
import 'app/core/utils/app_log.dart';
import 'app/core/utils/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/services/api_service.dart';
import 'app/services/app_binding.dart';
import 'app/services/auth_service.dart';
import 'app/services/localization_service.dart';
import 'app/services/token_storage_service.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  /// Catch Flutter framework errors (widget build errors, rendering issues)
  FlutterError.onError = (FlutterErrorDetails details) {
    logger.e(
      'Flutter error: ${details.exception}',
      error: details.exception,
      stackTrace: details.stack,
    );
    if (kDebugMode) FlutterError.presentError(details);
  };

  /// Catch uncaught Dart errors outside Flutter framework (async, isolates)
  PlatformDispatcher.instance.onError = (error, stack) {
    logger.e('Uncaught error: $error', error: error, stackTrace: stack);
    return true;
  };

  /// Splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// Force portrait mode
  await SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp]);

  /// Local key-value (non-sensitive prefs)
  await GetStorage.init();

  /// Load environment and set app config
  await _loadEnvironment();

  /// Core services (secure token store, HTTP client, auth)
  await _registerCoreServices();

  /// Run Application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
      onReady: () async {
        FlutterNativeSplash.remove();
      },
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

Future<void> _registerCoreServices() async {
  await Get.putAsync<TokenStorageService>(
    () async {
      final TokenStorageService s = TokenStorageService();
      return s.init();
    },
    permanent: true,
  );
  Get.put(ApiService(), permanent: true);
  await Get.putAsync<AuthService>(
    () async {
      final AuthService auth = AuthService();
      return auth.init();
    },
    permanent: true,
  );
}
