import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/models/token_model.dart';
import '../routes/app_pages.dart';

class AuthService extends GetxService {
  /// Storage
  static GetStorage box = GetStorage();

  static AuthService get get => Get.find<AuthService>();

  Future<AuthService> init() async {
    return this;
  }

  /// Token
  Token? _token;

  get token => _token;

  @override
  void onInit() {
    super.onInit();

    /// Get Token from get storage
    if (box.hasData(Token.localKey)) {
      _token = Token.fromJson(box.read(Token.localKey));
    }

    /// listen for token value
    /// If token value is null then automatically redirect to INIT page
    box.listenKey(Token.localKey, (newToken) {
      if (newToken == null) {
        handleLogout();
      }
      _token = newToken;
    });
  }

  bool logged() => _token != null;

  void clear() {
    _token = Token.empty();
  }

  Future<void> handleLogout() async {
    // Call api logout here

    // Clear GetStorage
    box.erase();

    // Clear token
    _token = null;

    // Navigate to ONBOARDING screen
    Get.offAllNamed(Routes.ONBOARDING);
  }
}
