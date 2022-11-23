import 'package:get/get.dart';

import '../../core/utils/app_config.dart';

class BaseProvider extends GetConnect {
  @override
  void onInit() {
    /// Get base url by env
    httpClient.baseUrl = AppConfig.I.env.apiBaseUrl;

    /// Timeout
    httpClient.timeout = const Duration(seconds: 30);
  }
}
