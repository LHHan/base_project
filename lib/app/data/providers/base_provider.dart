import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import '../../core/utils/app_config.dart';

class BaseProvider extends GetConnect {
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
      // request.headers['Authorization'] = 'Bearer {AccessToken}';
      return request;
    });

    httpClient.addAuthenticator((Request request) async {
      /// Call refresh token

      /// Add header authorization
      // request.headers['Authorization'] = 'Bearer {AccessToken}';
      return request;
    });

    /// Authenticator will be called 3 times if HttpStatus is
    /// HttpStatus.unauthorized
    httpClient.maxAuthRetries = 3;
  }
}
