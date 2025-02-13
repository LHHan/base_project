import 'package:base_project_getx/app/data/models/home_model.dart';
import 'package:base_project_getx/app/services/api_service.dart';
import 'package:dio/dio.dart';

class HomeProvider extends ApiService {
  final String _pathApi = '/path/api';

  Future<HomeModel> getHomeData() async {
    Response? response = await get(_pathApi);

    return response.data;
  }
}
