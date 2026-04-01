import 'package:get/get.dart';

import '../data/models/token_model.dart';
import '../routes/app_pages.dart';
import 'token_storage_service.dart';

class AuthService extends GetxService {
  static AuthService get get => Get.find<AuthService>();

  Token? _token;

  Token? get token => _token;

  Future<AuthService> init() async {
    _token = await Get.find<TokenStorageService>().readToken();
    return this;
  }

  bool logged() =>
      _token != null &&
      _token!.accessToken.isNotEmpty;

  void clear() {
    _token = Token.empty();
  }

  /// Clears in-memory token after secure storage was wiped (e.g. API logout).
  void clearToken() {
    _token = null;
  }

  Future<void> syncTokenFromStorage() async {
    _token = await Get.find<TokenStorageService>().readToken();
  }

  Future<void> handleLogout() async {
    // Call api logout here if needed.

    await Get.find<TokenStorageService>().clearAuth();
    _token = null;

    Get.offAllNamed(Routes.ONBOARDING);
  }
}
