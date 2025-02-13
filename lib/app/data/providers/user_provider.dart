import 'dart:convert';

import 'package:base_project_getx/app/core/utils/app_helper.dart';
import 'package:base_project_getx/app/services/api_service.dart';

import '../models/user_model.dart';

class UserProvider extends ApiService {
  final String _users = '/users';

  /// Call API to get the list of users
  Future<List<UserModel>> getUsers() async {
    final response = await get(_users,
        overrideBaseUrl: 'https://jsonplaceholder.typicode.com');

    if (response.statusCode == 200) {
      // Use a utility function to process JSON in an Isolate
      return await AppHelper()
          .parseJsonWithIsolate(jsonEncode(response.data), UserModel.fromJson);
    }

    // Return an empty list if an error occurs
    return [];
  }
}
