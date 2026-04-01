import 'package:get/get.dart';

import '../core/utils/app_helper.dart';

/// Mixin that wraps API calls with standardized lifecycle hooks and error handling.
///
/// Apply to any [GetxController] that makes API calls:
/// ```dart
/// class MyController extends GetxController with RestApiSafety {
///   Future<void> loadData() async {
///     await apiCallSafety(
///       () => _provider.getData(),
///       onStart: () async => isLoading.value = true,
///       onCompleted: (ok, res) async {
///         if (ok && res != null) data.value = res;
///         isLoading.value = false;
///       },
///     );
///   }
/// }
/// ```
///
/// **Execution order:**
/// ```
/// onStart → API call → onCompleted(true, result)  → onFinally
///                  └─► onCompleted(false, null)    → onError → onFinally
/// ```
mixin RestApiSafety {
  /// Executes [apiCall] safely with optional lifecycle callbacks.
  ///
  /// - [apiCall] — the async function that performs the API request.
  /// - [onStart] — called before the API call; typically shows a loading indicator.
  /// - [onCompleted] — called after success **or** failure:
  ///     - `status = true` on success, `status = false` on error.
  ///     - `res` is the result on success, `null` on error.
  /// - [onError] — called only on failure; receives the thrown error.
  /// - [onFinally] — always called at the end, regardless of outcome.
  /// - [skipErrorMessage] — set to `true` to suppress the automatic snackbar on error.
  ///
  /// Returns the result on success, or `null` on failure.
  Future<T?> apiCallSafety<T>(
    Future<T> Function() apiCall, {
    Future<void> Function()? onStart,
    Future<void> Function(dynamic error)? onError,
    Future<void> Function(bool status, T? res)? onCompleted,
    Future<void> Function()? onFinally,
    bool skipErrorMessage = false,
  }) async {
    try {
      if (onStart != null) await onStart();

      final T res = await apiCall();

      if (onCompleted != null) await onCompleted(true, res);

      return res;
    } catch (error) {
      if (onCompleted != null) onCompleted(false, null);

      if (onError != null) await onError(error);

      if (!skipErrorMessage && !Get.isSnackbarOpen) {
        AppHelper.showErrorMessage(
          error is Map
              ? (error as Map<String, dynamic>).values.join('\n')
              : error.toString(),
        );
      }

      return null;
    } finally {
      if (onFinally != null) await onFinally();
    }
  }
}
