import 'package:get/get.dart';

import '../../../data/providers/feed_provider.dart';
import '../controllers/feed_controller.dart';

class FeedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedProvider>(() => FeedProvider());
    Get.lazyPut<FeedController>(
      () => FeedController(feedProvider: Get.find()),
    );
  }
}
