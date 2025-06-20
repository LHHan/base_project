import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/models/token_model.dart';

class AuthService extends GetxService {
  /// Storage
  static GetStorage box = GetStorage();

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
        box.erase();
        // TODO: Redirect to init page
      }
      _token = newToken;
    });
  }

  bool logged() => _token != null;

  void clear() {
    _token = Token.empty();
  }
}
