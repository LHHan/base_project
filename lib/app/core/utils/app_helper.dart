/* Define app helper. Provide util function such as show popup, toast, flush bar, orientation mode */

import 'dart:convert';
import 'dart:isolate';

class AppHelper {
  static final AppHelper _singleton = AppHelper._internal();

  factory AppHelper() {
    return _singleton;
  }

  AppHelper._internal();

  // Function parse JSON to List<T> with isolate
  Future<List<T>> parseJsonWithIsolate<T>(
      String jsonString, T Function(Map<String, dynamic>) fromJson) async {
    final ReceivePort receivePort = ReceivePort();

    await Isolate.spawn(
        _parseJson, [receivePort.sendPort, jsonString, fromJson]);

    // Receive data from Isolate and cast it to List<T>
    final result = await receivePort.first;
    return List<T>.from(result);
  }

  // Function running inside the Isolate
  void _parseJson<T>(List<dynamic> args) {
    SendPort sendPort = args[0];
    String jsonString = args[1];
    T Function(Map<String, dynamic>) fromJson = args[2];

    // Decode JSON into a List<dynamic>
    final List<dynamic> jsonList = jsonDecode(jsonString);

    // Convert each item to an object of type T
    final List<T> parsedList =
        jsonList.map((json) => fromJson(json as Map<String, dynamic>)).toList();

    // Send parsed data back to the main thread
    sendPort.send(parsedList);
  }
}
