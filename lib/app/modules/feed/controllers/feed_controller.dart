import 'package:base_project_getx/app/data/models/product_model.dart';
import 'package:base_project_getx/app/data/providers/feed_provider.dart';
import 'package:base_project_getx/app/services/rest_api_safety.dart';
import 'package:get/get.dart';

class FeedController extends GetxController with RestApiSafety {
  FeedController({required FeedProvider feedProvider})
      : _feedProvider = feedProvider;

  final FeedProvider _feedProvider;

  var products = <ProductModel>[].obs;
  var isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    await apiCallSafety(
      () => _feedProvider.getFeedProducts(),
      onStart: () async => isLoading.value = true,
      onCompleted: (status, res) async {
        if (status && res != null) products.assignAll(res);
        isLoading.value = false;
      },
    );
  }

  Future<void> onRefresh() async {
    products.clear();
    await fetchProducts();
  }
}
