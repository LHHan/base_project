import 'dart:async';

import 'package:base_project_getx/app/routes/app_pages.dart';
import 'package:base_project_getx/app/services/auth_service.dart';
import 'package:base_project_getx/app/services/token_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../core/utils/app_config.dart';
import '../core/utils/app_log.dart';

/// Centralized HTTP client for the application.
///
/// Built on top of [Dio] with the following features:
///
/// **Token management**
/// - Automatically attaches `Authorization: Bearer <token>` to every request.
/// - Tokens are persisted in [TokenStorageService] (secure storage).
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
/// Authorization headers are redacted in logs.
class ApiService extends GetxService {
  late final Dio _dio;
  final TokenStorageService _tokenStorage = TokenStorageService.I;

  bool _isRefreshing = false;
  Future<void>? _refreshFuture;

  final String apiBaseUrl = AppConfig.I.env.apiBaseUrl;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll(
      [
        QueuedInterceptorsWrapper(
          onRequest: (options, handler) async {
            final String? access = await _tokenStorage.readAccessToken();
            if (access != null && access.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $access';
            }
            handler.next(options);
          },
          onResponse: (response, handler) {
            handler.next(response);
          },
          onError: (DioException e, handler) async {
            if (e.response?.statusCode == 401 &&
                e.requestOptions.extra['refresh'] != true) {
              logger.e('🔴 Unauthorized error - trying refresh token...');
              final bool success = await _handleRefreshToken();

              if (success) {
                logger.i('✅ Token refreshed, retrying request...');
                final RequestOptions requestOptions = e.requestOptions;
                final String? access = await _tokenStorage.readAccessToken();
                if (access != null && access.isNotEmpty) {
                  requestOptions.headers['Authorization'] = 'Bearer $access';
                }

                try {
                  final Response<dynamic> clonedRequest =
                      await _dio.fetch(requestOptions);
                  return handler.resolve(clonedRequest);
                } catch (err) {
                  return handler.reject(handleError(err as DioException));
                }
              }
            }

            logger.e('❌ API Request failed: ${e.message}');
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
          logPrint: _redactedLogPrint,
        ),
      ],
    );
  }

  void _redactedLogPrint(Object object) {
    final String line = object.toString();
    logger.d(_redactAuthInLogLine(line));
  }

  static String _redactAuthInLogLine(String line) {
    return line.replaceAllMapped(
      RegExp(r'Bearer\s+[^\s]+', caseSensitive: false),
      (_) => 'Bearer ***',
    );
  }

  /// Maps [DioExceptionType] to a user-friendly error message.
  DioException handleError(DioException error) {
    final Map<DioExceptionType, String> messages = <DioExceptionType, String>{
      DioExceptionType.connectionTimeout:
          '⏳ Connection timeout. Please try again.',
      DioExceptionType.sendTimeout:
          '⏳ Request timeout. Please check your connection.',
      DioExceptionType.receiveTimeout:
          '⏳ Server response timeout. Please try again later.',
      DioExceptionType.badResponse:
          '⚠️ Server error: ${error.response?.statusCode}. Please try again.',
      DioExceptionType.cancel: '🚫 Request was cancelled.',
      DioExceptionType.unknown:
          '❓ An unknown error occurred: ${error.message}',
    };

    return error.copyWith(
      message: messages[error.type] ??
          '⚠️ Something went wrong: ${error.message}',
    );
  }

  Future<bool> _handleRefreshToken() async {
    if (_isRefreshing) {
      await _refreshFuture;
      return await _tokenStorage.readAccessToken() != null;
    }

    final String? refresh = await _tokenStorage.readRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      if (kDebugMode) {
        logger.e('⚠️ No refresh token available.');
      }
      await _logout();
      return false;
    }

    _isRefreshing = true;
    _refreshFuture = _refreshTokenRequest();

    try {
      await _refreshFuture;
      return await _tokenStorage.readAccessToken() != null;
    } catch (_) {
      await _logout();
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _refreshTokenRequest() async {
    try {
      final String? refreshToken = await _tokenStorage.readRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await _clearTokens();
        throw StateError('No refresh token');
      }

      final Response<dynamic> response = await _dio.post(
        '/auth/refresh',
        data: <String, dynamic>{'refreshToken': refreshToken},
        options: Options(
          headers: <String, dynamic>{
            'Authorization': 'Bearer $refreshToken',
          },
          extra: <String, dynamic>{'refresh': true},
        ),
      );

      await _tokenStorage.saveTokensFromStrings(
        accessToken: response.data['accessToken'] as String,
        refreshToken: response.data['refreshToken'] as String,
      );

      await _syncAuthServiceToken();

      _dio.options.headers['Authorization'] =
          'Bearer ${await _tokenStorage.readAccessToken()}';

      if (kDebugMode) {
        logger.i('🔄 Token refreshed successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        logger.e('⚠️ Refresh token failed: $e');
      }

      await _clearTokens();
      rethrow;
    }
  }

  Future<void> _clearTokens() async {
    await _tokenStorage.clearAuth();
    if (Get.isRegistered<AuthService>()) {
      Get.find<AuthService>().clearToken();
    }
  }

  Future<void> _syncAuthServiceToken() async {
    if (Get.isRegistered<AuthService>()) {
      await Get.find<AuthService>().syncTokenFromStorage();
    }
  }

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    return _dio.get(path, queryParameters: queryParams);
  }

  Future<Response<dynamic>> post(String path, {dynamic data}) async {
    return _dio.post(path, data: data);
  }

  Future<Response<dynamic>> put(String path, {dynamic data}) async {
    return _dio.put(path, data: data);
  }

  Future<Response<dynamic>> delete(String path, {dynamic data}) async {
    return _dio.delete(path, data: data);
  }

  Future<ApiService> init() async {
    return this;
  }

  static ApiService get defined => Get.find<ApiService>();

  Future<void> logout() async {
    await _logout();
  }

  Future<void> _logout() async {
    await _clearTokens();

    if (kDebugMode) {
      logger.i('🚪 Logging out... Redirecting to login screen.');
    }

    Get.offAllNamed(Routes.HOME);
  }
}
