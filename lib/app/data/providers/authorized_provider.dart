import 'package:base_project_getx/app/core/utils/app_log.dart';
import 'package:base_project_getx/app/data/providers/base_provider.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import '../models/token_model.dart';

class AuthorizedProvider extends BaseProvider {
  /// Credential info
  Token? token;

  @override
  void onInit() async {
    super.onInit();

    /// ****
    ///
    /// Provider is coding
    ///
    /// ****

    /// It's will attach 'Authorization' property on header from all requests
    httpClient.addRequestModifier((request) {
      if (token != null) {
        request.headers['Authorization'] = 'Bearer ${token?.accessToken}';
      } else {
        logger.e('Access Token is null');
        return Future.error('Access Token is null');
      }
      return request;
    });

    httpClient.addAuthenticator((Request request) async {
      if (token != null) {
        request.headers['Authorization'] = 'Bearer ${token?.accessToken}';
      } else {
        logger.e('Access Token is null');
        return Future.error('Access Token is null');
      }
      return request;
    });

    /// Authenticator will be called 3 times if HttpStatus is
    /// HttpStatus.unauthorized
    httpClient.maxAuthRetries = 3;
  }
}
