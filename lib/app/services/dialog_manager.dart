import 'package:base_project_getx/app/widgets/p_appbar_transparency.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../core/utils/app_asset.dart';
import '../core/utils/app_log.dart';

class DialogManager {
  static final Map<String, bool> _dialogs = {};
  static bool _isLoadingShowing = false;

  /// Show a dialog with a unique ID
  static Future<T?> showDialog<T>({
    required String id,
    required Widget child,
    bool barrierDismissible = false,
    Color? barrierColor,
    Object? arguments,
  }) async {
    if (_dialogs.containsKey(id) && _dialogs[id] == true) return null;

    _dialogs[id] = true;
    final result = await Get.dialog<T>(child,
        name: id,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor ?? Colors.black38,
        arguments: arguments);

    _dialogs.remove(id);
    return result;
  }

  /// Close a dialog by its ID
  static void closeDialog(String id) {
    if (_dialogs.containsKey(id) && Get.isDialogOpen == true) {
      Get.until((route) => route.settings.name != id);
      _dialogs.remove(id);
    }
  }

  /// Close all dialogs
  static void closeAllDialogs() {
    if (Get.isDialogOpen == true) {
      Get.back(closeOverlays: true);
      _dialogs.clear();
    }
  }

  /// Execute an action with a loading indicator
  static Future<T?> actionWithLoading<T>(Future<T> Function() action) async {
    await showLoading();
    try {
      return await action();
    } catch (e) {
      logger.e(e);
      return null;
    } finally {
      await hideLoading();
    }
  }

  /// Show loading dialog (ensure it is not reopened if already showing)
  static Future<void> showLoading({bool? barrierDismissible}) async {
    if (_isLoadingShowing) return;

    _isLoadingShowing = true;

    showDialog(
      id: 'idDialogLoading',
      barrierDismissible: barrierDismissible ?? false,
      child: PAppbarTransparency(
        child: Container(
          alignment: Alignment.center,
          child: Lottie.asset(
            AppAssets().lotLoading,
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }

  /// Hide loading dialog (ensure only the loading dialog is closed)
  static Future<void> hideLoading() async {
    if (_isLoadingShowing && _dialogs.containsKey('idDialogLoading')) {
      await Future.delayed(
        const Duration(milliseconds: 600),
        () {
          _isLoadingShowing = false;
          closeDialog('idDialogLoading');
        },
      );
    }
  }
}
