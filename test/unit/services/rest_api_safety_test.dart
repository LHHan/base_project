import 'package:base_project_getx/app/services/rest_api_safety.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _FakeController extends GetxController with RestApiSafety {}

void main() {
  late _FakeController controller;

  setUp(() {
    controller = _FakeController();
  });

  tearDown(() => Get.reset());

  group('RestApiSafety.apiCallSafety', () {
    test('returns result on success', () async {
      final result = await controller.apiCallSafety(
        () async => 42,
        skipErrorMessage: true,
      );

      expect(result, 42);
    });

    test('calls onStart before executing the API function', () async {
      bool startCalled = false;

      await controller.apiCallSafety(
        () async => 'ok',
        onStart: () async => startCalled = true,
        skipErrorMessage: true,
      );

      expect(startCalled, isTrue);
    });

    test('calls onCompleted with status=true and result on success', () async {
      bool? completedStatus;
      String? completedResult;

      await controller.apiCallSafety(
        () async => 'hello',
        onCompleted: (status, res) async {
          completedStatus = status;
          completedResult = res;
        },
        skipErrorMessage: true,
      );

      expect(completedStatus, isTrue);
      expect(completedResult, 'hello');
    });

    test('returns null on exception', () async {
      final result = await controller.apiCallSafety(
        () async => throw Exception('network error'),
        skipErrorMessage: true,
      );

      expect(result, isNull);
    });

    test('calls onCompleted with status=false on exception', () async {
      bool? completedStatus;

      await controller.apiCallSafety(
        () async => throw Exception('fail'),
        onCompleted: (status, res) async => completedStatus = status,
        skipErrorMessage: true,
      );

      expect(completedStatus, isFalse);
    });

    test('calls onError callback on exception', () async {
      dynamic capturedError;

      await controller.apiCallSafety(
        () async => throw Exception('boom'),
        onError: (e) async => capturedError = e,
        skipErrorMessage: true,
      );

      expect(capturedError, isA<Exception>());
    });

    test('calls onFinally regardless of success or failure', () async {
      bool finallyCalled = false;

      // success case
      await controller.apiCallSafety(
        () async => 'ok',
        onFinally: () async => finallyCalled = true,
        skipErrorMessage: true,
      );
      expect(finallyCalled, isTrue);

      finallyCalled = false;

      // failure case
      await controller.apiCallSafety(
        () async => throw Exception('fail'),
        onFinally: () async => finallyCalled = true,
        skipErrorMessage: true,
      );
      expect(finallyCalled, isTrue);
    });

    test('executes onStart then api then onCompleted in order', () async {
      final order = <String>[];

      await controller.apiCallSafety(
        () async {
          order.add('api');
          return 'result';
        },
        onStart: () async => order.add('start'),
        onCompleted: (_, __) async => order.add('completed'),
        skipErrorMessage: true,
      );

      expect(order, ['start', 'api', 'completed']);
    });
  });
}
