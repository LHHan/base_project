import 'package:get/get.dart';

import '../../../data/providers/user_provider.dart';
import '../controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProvider>(() => UserProvider());
    Get.lazyPut<ChatController>(
      () => ChatController(userProvider: Get.find()),
    );
  }
}
