import 'package:base_project_getx/app/core/utils/app_log.dart';
import 'package:base_project_getx/app/data/models/product_model.dart';
import 'package:base_project_getx/app/data/providers/user_provider.dart';
import 'package:get/get.dart';

import '../../../data/models/user_model.dart';
import '../../../data/providers/product_provider.dart';

class IsolateController extends GetxController {
  final _userProvider = Get.find<UserProvider>();
  final _productProvider = Get.find<ProductProvider>();

  final _usersData = <UserModel>[];
  var filterUsersData = <UserModel>[].obs;

  final _productsData = <ProductModel>[];
  var filterProductsData = <ProductModel>[].obs;

  var selectedSegment = 0.obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    logger.i(
        "onInit(): Khởi tạo dữ liệu, đăng ký listener, lấy dữ liệu từ cache");
  }

  @override
  void onReady() {
    super.onReady();

    logger.i(
        "onReady(): Gọi API lần đầu, hiển thị dialog/snackbar, thực hiện các tác vụ sau khi UI sẵn sàng");

    // Gọi API get users data and products data
    Future.wait([
      fetchUsersData(),
      fetchProductsData(),
    ]);
  }

  @override
  void onClose() {
    super.onClose();
    logger.i("onClose(): Hủy listener, giải phóng tài nguyên");
  }

  Future<void> onSearchData({required String query}) async {
    isLoading.value = true;

    if (selectedSegment.value == 0) {
      if (query.isEmpty) {
        filterUsersData.value = _usersData;
      } else {
        filterUsersData.value = _usersData
            .where((item) =>
                item.firstName.toLowerCase().contains(query.toLowerCase()) ||
                item.lastName.toLowerCase().contains(query.toLowerCase()) ||
                item.id.toString().contains(query.toLowerCase()))
            .toList();
      }
    } else {
      if (query.isEmpty) {
        filterProductsData.value = _productsData;
      } else {
        filterProductsData.value = _productsData
            .where((item) =>
                item.title.toLowerCase().contains(query.toLowerCase()) ||
                item.brand.toLowerCase().contains(query.toLowerCase()) ||
                item.category.toString().contains(query.toLowerCase()))
            .toList();
      }
    }

    isLoading.value = false;
  }

  Future<void> onChangedSegment({required int segment}) async {
    selectedSegment.value = segment;
  }

  Future<void> fetchUsersData() async {
    isLoading.value = true;

    List<UserModel> parsedUsers = await _userProvider.getUsers();

    _usersData.assignAll(parsedUsers);
    filterUsersData.assignAll(_usersData);
    isLoading.value = false;
  }

  Future<void> fetchProductsData() async {
    isLoading.value = true;

    List<ProductModel> parsedProducts = await _productProvider.getProducts();

    _productsData.assignAll(parsedProducts);
    filterProductsData.assignAll(_productsData);
    isLoading.value = false;
  }
}
