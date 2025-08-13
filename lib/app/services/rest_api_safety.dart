import 'package:get/get.dart';

import '../core/utils/app_helper.dart';

mixin RestApiSafety {
  /// Call api safety with error handling.
  /// Required:
  /// - shareGanttApi: call async api function in provider files
  /// Optional:
  /// - onStart: the function executed before api, can be null
  /// - onError: the function executed in case api crashed, can be null
  /// - onCompleted: the function executed after api or before crashing, can be null
  /// - onFinally: the function executed end of function, can be null
  /// - skipErrorMessage: false as default if you want to show error message
  Future<T?> apiCallSafety<T>(
    Future<T> Function() shareGanttApi, {
    Future<void> Function()? onStart,
    Future<void> Function(dynamic error)? onError,
    Future<void> Function(bool status, T? res)? onCompleted,
    Future<void> Function()? onFinally,
    bool skipErrorMessage = false,
  }) async {
    try {
      /// On start, use for show loading
      if (onStart != null) {
        await onStart();
      }

      /// Execute api
      final T res = await shareGanttApi();

      /// On completed, use for hide loading
      if (onCompleted != null) {
        await onCompleted(true, res);
      }

      /// Return api response
      return res;
    } catch (error) {
      /// In case error:
      /// On completed, use for hide loading
      if (onCompleted != null) {
        onCompleted(false, null);
      }

      /// On inline error
      if (onError != null) {
        await onError(error);
      }

      /// Skip or show error message
      if (skipErrorMessage == false) {
        if (!Get.isSnackbarOpen) {
          AppHelper.showErrorMessage(
            error is Map
                ? (error as Map<String, dynamic>).values.join('\n')
                : error.toString(),
          );
        }
      }

      return null;
    } finally {
      /// Call finally function
      if (onFinally != null) {
        await onFinally();
      }
    }
  }
}
