import 'package:get/get.dart';

import '../../../data/providers/user_provider.dart';
import '../../../services/api_service.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProvider>(
      () => UserProvider(Get.find<ApiService>()),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(userProvider: Get.find()),
    );
  }
}
