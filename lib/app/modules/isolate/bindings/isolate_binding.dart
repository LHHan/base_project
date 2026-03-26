import 'package:get/get.dart';

import '../../../data/providers/product_provider.dart';
import '../../../data/providers/user_provider.dart';
import '../controllers/isolate_controller.dart';

class IsolateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProvider>(() => UserProvider());
    Get.lazyPut<ProductProvider>(() => ProductProvider());
    Get.lazyPut<IsolateController>(
      () => IsolateController(
        userProvider: Get.find(),
        productProvider: Get.find(),
      ),
    );
  }
}
