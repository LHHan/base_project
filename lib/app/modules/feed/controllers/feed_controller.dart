import 'package:base_project_getx/app/data/models/feed_model.dart';
import 'package:base_project_getx/app/data/providers/feed_provider.dart';
import 'package:base_project_getx/app/services/rest_api_safety.dart';
import 'package:get/get.dart';

class FeedController extends GetxController with RestApiSafety {
  FeedController({required FeedProvider feedProvider})
      : _feedProvider = feedProvider;

  final FeedProvider _feedProvider;

  var posts = <FeedModel>[].obs;
  var isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    await apiCallSafety(
      () => _feedProvider.getPosts(),
      onStart: () async => isLoading.value = true,
      onCompleted: (status, res) async {
        if (status && res != null) posts.assignAll(res);
        isLoading.value = false;
      },
    );
  }

  Future<void> onRefresh() async {
    posts.clear();
    await fetchPosts();
  }
}
