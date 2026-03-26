import 'package:base_project_getx/app/core/utils/app_log.dart';
import 'package:base_project_getx/app/data/models/product_model.dart';
import 'package:base_project_getx/app/data/providers/product_provider.dart';
import 'package:base_project_getx/app/data/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/models/user_model.dart';

class IsolateController extends GetxController {
  IsolateController({
    required UserProvider userProvider,
    required ProductProvider productProvider,
  })  : _userProvider = userProvider,
        _productProvider = productProvider;

  final UserProvider _userProvider;
  final ProductProvider _productProvider;

  final _usersData = <UserModel>[];
  var filterUsersData = <UserModel>[].obs;

  final _productsData = <ProductModel>[];
  var filterProductsData = <ProductModel>[].obs;

  var selectedSegment = 0.obs;
  final PageController pageController = PageController();

  final TextEditingController tecSearchUsers = TextEditingController();
  final TextEditingController tecSearchProducts = TextEditingController();

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

    Future.wait([
      fetchUsersData(),
      fetchProductsData(),
    ]);
  }

  @override
  void onClose() {
    pageController.dispose();
    tecSearchUsers.dispose();
    tecSearchProducts.dispose();
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
    pageController.animateToPage(
      segment,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    onSearchData(
        query: selectedSegment.value == 0
            ? tecSearchUsers.text
            : tecSearchProducts.text);
  }

  Future<void> fetchUsersData() async {
    isLoading.value = true;
    final parsedUsers = await _userProvider.getUsers();
    _usersData.assignAll(parsedUsers);
    filterUsersData.assignAll(_usersData);
    isLoading.value = false;
  }

  Future<void> fetchProductsData() async {
    isLoading.value = true;
    final parsedProducts = await _productProvider.getProducts();
    _productsData.assignAll(parsedProducts);
    filterProductsData.assignAll(_productsData);
    isLoading.value = false;
  }
}
