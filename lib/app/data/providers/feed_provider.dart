import 'dart:convert';

import 'package:base_project_getx/app/core/utils/app_helper.dart';
import 'package:base_project_getx/app/data/models/feed_model.dart';
import 'package:base_project_getx/app/services/api_service.dart';

class FeedProvider {
  FeedProvider(this._api);

  final ApiService _api;

  static const String _posts = 'https://dummyjson.com/posts';

  Future<List<FeedModel>> getPosts() async {
    final response = await _api.get(_posts);
    if (response.statusCode == 200) {
      return AppHelper().parseJsonWithIsolate(
        jsonEncode(response.data['posts']),
        FeedModel.fromJson,
      );
    }
    return [];
  }
}
