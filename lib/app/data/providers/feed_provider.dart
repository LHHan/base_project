import 'dart:convert';

import 'package:base_project_getx/app/core/utils/app_helper.dart';
import 'package:base_project_getx/app/services/api_service.dart';

import '../models/product_model.dart';

class FeedProvider extends ApiService {
  final String _products = 'https://dummyjson.com/products';

  Future<List<ProductModel>> getFeedProducts() async {
    final response = await get(_products);

    if (response.statusCode == 200) {
      return await AppHelper().parseJsonWithIsolate(
          jsonEncode(response.data['products']), ProductModel.fromJson);
    }

    return [];
  }
}
