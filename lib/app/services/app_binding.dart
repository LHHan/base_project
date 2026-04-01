import 'package:get/get.dart';

/// Route-level bindings for the root graph.
///
/// Core services (`TokenStorageService`, `ApiService`, `AuthService`) are
/// registered in `main` before `runApp` so module bindings can use
/// `Get.find<ApiService>()`.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    injectBinding();
  }

  void injectBinding() {}
}
