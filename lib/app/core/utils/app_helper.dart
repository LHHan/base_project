import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Application-wide helper utilities.
///
/// Provides UI helpers (snackbars) and performance utilities (isolate parsing).
class AppHelper {
  static final AppHelper _singleton = AppHelper._internal();

  factory AppHelper() => _singleton;

  AppHelper._internal();

  // ---------------------------------------------------------------------------
  // Snack bars
  // ---------------------------------------------------------------------------

  /// Shows a red error snackbar with the given [error] message.
  static void showErrorMessage(String error) {
    Get.snackbar(
      'labelError'.tr,
      error,
      icon: const Icon(Icons.error, color: Color(0xFFB00020)),
      shouldIconPulse: true,
      onTap: (snack) => {},
      isDismissible: true,
      duration: const Duration(seconds: 3),
    );
  }

  /// Shows a green success snackbar with the given [message].
  static void showSuccessMessage(String message, {Color? backgroundColor}) {
    Get.snackbar(
      'labelOK'.tr,
      message,
      icon: const Icon(Icons.check_circle, color: Color(0xFF477256)),
      backgroundColor: backgroundColor,
      shouldIconPulse: true,
      onTap: (snack) => {},
      isDismissible: true,
      duration: const Duration(seconds: 3),
    );
  }

  // ---------------------------------------------------------------------------
  // Isolate JSON parsing
  // ---------------------------------------------------------------------------

  /// Parses a JSON array string into a [List<T>] on a separate [Isolate].
  ///
  /// Use this for large API responses to avoid blocking the main (UI) thread.
  ///
  /// **Flow:**
  /// ```
  /// Main thread                       Isolate
  ///    │                                 │
  ///    ├─ spawn Isolate ────────────────►│
  ///    │  (sendPort, jsonString, fromJson)│
  ///    │                                 ├─ jsonDecode(jsonString)
  ///    │                                 ├─ map each item with fromJson()
  ///    │◄─────────────────── sendPort ───┤
  ///    │  receive List<T>                │
  ///    └─ return result
  /// ```
  ///
  /// Example:
  /// ```dart
  /// final users = await AppHelper().parseJsonWithIsolate(
  ///   jsonEncode(response.data['users']),
  ///   UserModel.fromJson,
  /// );
  /// ```
  Future<List<T>> parseJsonWithIsolate<T>(
    String jsonString,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final receivePort = ReceivePort();

    await Isolate.spawn(
        _parseJson, [receivePort.sendPort, jsonString, fromJson]);

    final result = await receivePort.first;
    return List<T>.from(result);
  }

  /// Entry point executed inside the spawned [Isolate].
  ///
  /// Receives [args] as: `[SendPort, jsonString, fromJson]`
  void _parseJson<T>(List<dynamic> args) {
    final SendPort sendPort = args[0];
    final String jsonString = args[1];
    final T Function(Map<String, dynamic>) fromJson = args[2];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    final List<T> parsedList =
        jsonList.map((json) => fromJson(json as Map<String, dynamic>)).toList();

    sendPort.send(parsedList);
  }
}
