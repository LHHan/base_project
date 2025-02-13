import 'dart:async';

import 'package:base_project_getx/app/routes/app_pages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../core/utils/app_config.dart';
import '../core/utils/app_log.dart';

class ApiService extends GetxService {
  late Dio _dio;
  String? _accessToken;
  String? _refreshToken;
  bool _isRefreshing = false;
  Future<void>? _refreshFuture;

  final box = GetStorage();
  final String apiBaseUrl = AppConfig.I.env.apiBaseUrl;

  ApiService() {
    _loadTokens();

    _dio = Dio(
      BaseOptions(
        baseUrl: apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    _dio.interceptors.addAll(
      [
        QueuedInterceptorsWrapper(
          onRequest: (options, handler) {
            if (_accessToken != null) {
              options.headers['Authorization'] = 'Bearer $_accessToken';
            }
            return handler.next(options);
          },
          onResponse: (response, handler) {
            return handler.next(response);
          },
          onError: (DioException e, handler) async {
            if (e.response?.statusCode == 401 &&
                e.requestOptions.extra['refresh'] != true) {
              logger.e("🔴 Unauthorized error - trying refresh token...");
              final success = await _handleRefreshToken();

              if (success) {
                logger.i("✅ Token refreshed, retrying request...");
                final requestOptions = e.requestOptions;
                requestOptions.headers['Authorization'] =
                    'Bearer $_accessToken';

                try {
                  final clonedRequest = await _dio.fetch(requestOptions);
                  return handler.resolve(clonedRequest);
                } catch (e) {
                  return handler.reject(handleError(e as DioException));
                }
              }
            }

            logger.e("❌ API Request failed: ${e.message}");
            return handler.reject(handleError(e));
          },
        ),
        PrettyDioLogger(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
          enabled: kDebugMode,
        ),
      ],
    );
  }

  /// 🔹 Load accessToken, refreshToken từ GetStorage
  void _loadTokens() {
    _accessToken = box.read<String>('accessToken');
    _refreshToken = box.read<String>('refreshToken');
    if (kDebugMode) {
      logger.i("🔄 Loaded tokens: $_accessToken, $_refreshToken");
    }
  }

  /// 🔹 Set accessToken, refreshToken
  void _saveTokens(
      {required String accessToken, required String refreshToken}) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;

    box.write('accessToken', accessToken);
    box.write('refreshToken', refreshToken);

    if (kDebugMode) {
      logger.i("✅ Tokens saved: $accessToken, $refreshToken");
    }
  }

  /// 🔹 Clear accessToken, refreshToken
  void _clearTokens() {
    _accessToken = null;
    _refreshToken = null;
    box.remove('accessToken');
    box.remove('refreshToken');
  }

  /// 🟢 **GET request**
  Future<Response> get(String path,
      {Map<String, dynamic>? queryParams, String? overrideBaseUrl}) async {
    final requestOptions = Options(headers: {..._dio.options.headers});

    if (overrideBaseUrl != null) {
      requestOptions.extra = {'baseUrl': overrideBaseUrl};
    }

    return await _dio.get(path,
        queryParameters: queryParams, options: requestOptions);
  }

  /// 🟠 **POST request**
  Future<Response> post(String path,
      {dynamic data, String? overrideBaseUrl}) async {
    final requestOptions = Options(headers: {..._dio.options.headers});

    if (overrideBaseUrl != null) {
      requestOptions.extra = {'baseUrl': overrideBaseUrl};
    }

    return await _dio.post(path, data: data, options: requestOptions);
  }

  /// 🔵 **PUT request**
  Future<Response> put(String path,
      {dynamic data, String? overrideBaseUrl}) async {
    final requestOptions = Options(headers: {..._dio.options.headers});

    if (overrideBaseUrl != null) {
      requestOptions.extra = {'baseUrl': overrideBaseUrl};
    }

    return await _dio.put(path, data: data, options: requestOptions);
  }

  /// 🔴 **DELETE request**
  Future<Response> delete(String path,
      {dynamic data, String? overrideBaseUrl}) async {
    final requestOptions = Options(headers: {..._dio.options.headers});

    if (overrideBaseUrl != null) {
      requestOptions.extra = {'baseUrl': overrideBaseUrl};
    }

    return await _dio.delete(path, data: data, options: requestOptions);
  }

  /// 🚨 **Handle errors**
  DioException handleError(DioException error) {
    final messages = {
      DioExceptionType.connectionTimeout:
          "⏳ Connection timeout. Please try again.",
      DioExceptionType.sendTimeout:
          "⏳ Request timeout. Please check your connection.",
      DioExceptionType.receiveTimeout:
          "⏳ Server response timeout. Please try again later.",
      DioExceptionType.badResponse:
          "⚠️ Server error: ${error.response?.statusCode}. Please try again.",
      DioExceptionType.cancel: "🚫 Request was cancelled.",
      DioExceptionType.unknown: "❓ An unknown error occurred: ${error.message}",
    };

    return error.copyWith(
        message: messages[error.type] ??
            "⚠️ Something went wrong: ${error.message}");
  }

  /// 🔹 Xử lý refresh token khi bị 401
  Future<bool> _handleRefreshToken() async {
    if (_isRefreshing) {
      await _refreshFuture;
      return _accessToken != null;
    }

    if (_refreshToken == null || _refreshToken!.isEmpty) {
      if (kDebugMode) logger.e('⚠️ No refresh token available.');
      return false;
    }

    _isRefreshing = true;
    _refreshFuture = _refreshTokenRequest();

    try {
      await _refreshFuture;
      return _accessToken != null;
    } catch (e) {
      _logout();
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  /// 🛠 Thực hiện refresh token
  Future<void> _refreshTokenRequest() async {
    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': _refreshToken},
        options: Options(
            headers: {'Authorization': 'Bearer $_refreshToken'},
            extra: {'refresh': true}),
      );

      _saveTokens(
        accessToken: response.data['accessToken'],
        refreshToken: response.data['refreshToken'],
      );

      _dio.options.headers['Authorization'] = 'Bearer $_accessToken';

      if (kDebugMode) logger.i('🔄 Token refreshed successfully');
    } catch (e) {
      if (kDebugMode) logger.e('⚠️ Refresh token failed: $e');

      _clearTokens();
      rethrow;
    }
  }

  Future<ApiService> init() async {
    return this;
  }

  void _logout() {
    _clearTokens();
    if (kDebugMode) logger.i('🚪 Logging out... Redirecting to login screen.');

    Get.offAllNamed(Routes.HOME);
  }
}
