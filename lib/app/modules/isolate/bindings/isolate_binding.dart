import 'package:get/get.dart';

import '../../../data/providers/user_provider.dart';
import '../controllers/isolate_controller.dart';

class IsolateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IsolateController>(
      () => IsolateController(),
    );
    Get.lazyPut<UserProvider>(
      () => UserProvider(),
    );
  }
}
