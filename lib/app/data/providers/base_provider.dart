import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import '../../core/utils/app_config.dart';
import '../../services/auth_service.dart';

class BaseProvider extends GetConnect {
  /// Auth Service
  var authService = Get.find<AuthService>();

  @override
  void onInit() {
    /// Get base url by env
    httpClient.baseUrl = AppConfig.I.env.apiBaseUrl;

    /// Timeout
    httpClient.timeout = const Duration(seconds: 60);

    httpClient.addResponseModifier((Request request, Response response) async {
      return response;
    });

    /// It's will attach 'Authorization' property on header from all requests
    httpClient.addRequestModifier((Request request) async {
      if (authService.token != null) {
        request.headers['Authorization'] =
            'Bearer ${authService.token?.accessToken}';
      }
      return request;
    });

    httpClient.addAuthenticator((Request request) async {
      /// Call api refresh token

      /// Add header authorization
      if (authService.token != null) {
        request.headers['Authorization'] =
            'Bearer ${authService.token?.accessToken}';
      }
      return request;
    });

    /// Authenticator will be called 3 times if HttpStatus is
    /// HttpStatus.unauthorized
    httpClient.maxAuthRetries = 3;
  }
}
