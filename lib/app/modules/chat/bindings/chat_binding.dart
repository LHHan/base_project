import 'package:get/get.dart';

import '../../../data/providers/user_provider.dart';
import '../../../services/api_service.dart';
import '../controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProvider>(
      () => UserProvider(Get.find<ApiService>()),
    );
    Get.lazyPut<ChatController>(
      () => ChatController(userProvider: Get.find()),
    );
  }
}
