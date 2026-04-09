import 'package:base_project_getx/app/data/models/home_model.dart';
import 'package:base_project_getx/app/services/api_service.dart';
import 'package:dio/dio.dart';

/// Template provider — replace with your actual API endpoints.
///
/// Provider pattern:
/// - Receive [ApiService] via constructor injection (never `Get.find()` inside).
/// - Each method maps to one API endpoint.
/// - Return typed models; throw on unexpected response shapes.
///
/// Register in your binding:
/// ```dart
/// Get.lazyPut<HomeProvider>(() => HomeProvider(Get.find<ApiService>()));
/// ```
class HomeProvider {
  HomeProvider(this._api);

  final ApiService _api;

  // TODO: Replace with your actual API path.
  static const _path = '/path/api';

  Future<HomeModel> getHomeData() async {
    final Response<dynamic> response = await _api.get(_path);
    final dynamic data = response.data;
    if (data is Map<String, dynamic>) {
      return HomeModel.fromJson(data);
    }
    throw StateError('Unexpected home API response shape');
  }
}
