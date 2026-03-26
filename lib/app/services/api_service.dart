import 'dart:async';

import 'package:base_project_getx/app/routes/app_pages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../core/utils/app_config.dart';
import '../core/utils/app_log.dart';

/// Centralized HTTP client for the application.
///
/// Built on top of [Dio] with the following features:
///
/// **Token management**
/// - Automatically attaches `Authorization: Bearer <token>` to every request.
/// - Tokens are persisted in [GetStorage] and loaded lazily on first use.
///
/// **Automatic token refresh (401 flow)**
/// ```
/// Request → 401 Unauthorized
///     └─ _handleRefreshToken()
///           ├─ [concurrent] If already refreshing, wait for ongoing future
///           └─ [first caller] POST /auth/refresh → save new tokens
///                 ├─ success → retry original request with new token
///                 └─ failure → clear tokens → redirect to login
/// ```
///
/// **Queue-based interceptor** ([QueuedInterceptorsWrapper])
/// Ensures that when multiple requests fail with 401 simultaneously,
/// only one refresh call is made — others wait for it to complete.
///
/// **Logging**
/// [PrettyDioLogger] is enabled only in debug mode (`kDebugMode`).
class ApiService extends GetxService {
  late Dio _dio;
  String? _accessToken;
  String? _refreshToken;
  bool _isRefreshing = false;
  bool _isTokenLoaded = false;
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
            // Load tokens lazily — only when not yet loaded from storage
            if (!_isTokenLoaded) {
              _loadTokens();
            }

            if (_accessToken != null) {
              options.headers['Authorization'] = 'Bearer $_accessToken';
            }
            return handler.next(options);
          },
          onResponse: (response, handler) {
            return handler.next(response);
          },
          onError: (DioException e, handler) async {
            // Only attempt refresh for 401 errors that are not themselves
            // the refresh request (prevents infinite loop via extra['refresh'])
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
        // Only active in debug builds — silent in production
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

  /// Reads [_accessToken] and [_refreshToken] from persistent storage.
  void _loadTokens() {
    _accessToken = box.read<String>('accessToken');
    _refreshToken = box.read<String>('refreshToken');
    _isTokenLoaded = true;
    if (kDebugMode) logger.i("🔄 Tokens loaded from storage.");
  }

  /// Persists new tokens to storage and updates in-memory values.
  /// Resets [_isTokenLoaded] so the next request re-reads from storage.
  void _saveTokens(
      {required String accessToken, required String refreshToken}) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;

    box.write('accessToken', accessToken);
    box.write('refreshToken', refreshToken);

    _isTokenLoaded = false;

    if (kDebugMode) logger.i("✅ Tokens saved to storage.");
  }

  /// Removes tokens from memory and storage.
  void _clearTokens() {
    _accessToken = null;
    _refreshToken = null;
    box.remove('accessToken');
    box.remove('refreshToken');
  }

  /// GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await _dio.get(path, queryParameters: queryParams);
  }

  /// POST request
  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  /// PUT request
  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  /// DELETE request
  Future<Response> delete(String path, {dynamic data}) async {
    return await _dio.delete(path, data: data);
  }

  /// Maps [DioExceptionType] to a user-friendly error message.
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

  /// Handles concurrent 401 errors safely.
  ///
  /// If a refresh is already in progress, subsequent callers await the
  /// same [_refreshFuture] instead of triggering duplicate refresh calls.
  Future<bool> _handleRefreshToken() async {
    if (_isRefreshing) {
      await _refreshFuture;
      return _accessToken != null;
    }

    if (_refreshToken == null || _refreshToken!.isEmpty) {
      if (kDebugMode) logger.e('⚠️ No refresh token available.');
      _logout();
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

  /// Calls [POST /auth/refresh] with the current refresh token.
  ///
  /// Uses `extra: {'refresh': true}` to prevent the error interceptor
  /// from triggering another refresh cycle on a 401 response.
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

  static ApiService get defined => Get.find<ApiService>();

  Future<void> logout() async {
    _logout();
  }

  void _logout() {
    _clearTokens();
    box.erase();

    if (kDebugMode) logger.i('🚪 Logging out... Redirecting to login screen.');

    Get.offAllNamed(Routes.HOME);
  }
}
