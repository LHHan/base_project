import 'package:base_project_getx/app/data/models/home_model.dart';
import 'package:base_project_getx/app/services/api_service.dart';
import 'package:dio/dio.dart';

class HomeProvider {
  HomeProvider(this._api);

  final ApiService _api;

  final String _pathApi = '/path/api';

  Future<HomeModel> getHomeData() async {
    final Response<dynamic> response = await _api.get(_pathApi);
    final dynamic data = response.data;
    if (data is Map<String, dynamic>) {
      return HomeModel.fromJson(data);
    }
    throw StateError('Unexpected home API response shape');
  }
}
