import 'package:get/get.dart';

import '../../../data/providers/product_provider.dart';
import '../../../data/providers/user_provider.dart';
import '../../../services/api_service.dart';
import '../controllers/isolate_controller.dart';

class IsolateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProvider>(
      () => UserProvider(Get.find<ApiService>()),
    );
    Get.lazyPut<ProductProvider>(
      () => ProductProvider(Get.find<ApiService>()),
    );
    Get.lazyPut<IsolateController>(
      () => IsolateController(
        userProvider: Get.find<UserProvider>(),
        productProvider: Get.find<ProductProvider>(),
      ),
    );
  }
}
