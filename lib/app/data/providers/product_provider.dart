import 'dart:convert';

import 'package:base_project_getx/app/core/utils/app_helper.dart';
import 'package:base_project_getx/app/services/api_service.dart';

import '../models/product_model.dart';

class ProductProvider extends ApiService {
  final String _products = 'https://dummyjson.com/products';

  /// Call API to get the list of products
  Future<List<ProductModel>> getProducts() async {
    final response = await get(_products);

    if (response.statusCode == 200) {
      // Use a utility function to process JSON in an Isolate
      return await AppHelper().parseJsonWithIsolate(
          jsonEncode(response.data['products']), ProductModel.fromJson);
    }

    // Return an empty list if an error occurs
    return [];
  }
}
