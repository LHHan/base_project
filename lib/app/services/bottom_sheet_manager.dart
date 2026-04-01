import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetManager {
  /// Generic method to show bottom sheet with associated controller.
  ///
  /// T - Controller type
  /// R - Return result type (ex: Task)
  static Future<R?> showWithController<T extends GetxController, R>({
    required T Function() controllerBuilder,
    required Widget Function(T controller) builder,
    void Function(T controller)? onPrepare,
    bool shouldDisposeAfterUse = false,
    bool isDismissible = true,
    Color barrierColor = Colors.transparent,
    Color? backgroundColor,
    bool useSafeArea = true,
  }) async {
    // Inject controller
    if (!Get.isRegistered<T>()) {
      Get.lazyPut<T>(controllerBuilder);
    }

    final controller = Get.find<T>();

    // Set data (if have)
    if (onPrepare != null) onPrepare(controller);

    // Get context
    final context = Get.overlayContext ?? Get.context!;

    final result = await showModalBottomSheet<R>(
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      isDismissible: isDismissible,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      backgroundColor: backgroundColor,
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: builder(controller),
      ),
    );

    // Cleanup
    if (shouldDisposeAfterUse && Get.isRegistered<T>()) {
      Get.delete<T>();
    }

    return result;
  }
}
