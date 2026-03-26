import 'package:base_project_getx/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:base_project_getx/app/modules/notifications/views/notifications_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

Widget _buildTestWidget() {
  return ScreenUtilInit(
    designSize: const Size(428, 926),
    child: GetMaterialApp(
      home: const NotificationsView(),
      initialBinding: BindingsBuilder(() {
        Get.put(NotificationsController());
      }),
    ),
  );
}

void main() {
  tearDown(() => Get.reset());

  group('NotificationsView', () {
    testWidgets('renders Notifications title', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pump();

      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('shows mock notifications list', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pump();

      expect(find.text('Welcome!'), findsOneWidget);
      expect(find.text('New message'), findsOneWidget);
    });

    testWidgets('shows Mark all read button when unread exist', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pump();

      expect(find.text('Mark all read'), findsOneWidget);
    });

    testWidgets('Mark all read hides button when all are read', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pump();

      await tester.tap(find.text('Mark all read'));
      await tester.pump();

      expect(find.text('Mark all read'), findsNothing);
    });

    testWidgets('tapping a notification marks it as read', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pump();

      final controller = Get.find<NotificationsController>();
      final initialUnread = controller.unreadCount.value;

      await tester.tap(find.text('Welcome!'));
      await tester.pump();

      expect(controller.unreadCount.value, lessThan(initialUnread));
    });
  });

  group('NotificationsController', () {
    late NotificationsController controller;

    setUp(() {
      controller = Get.put(NotificationsController());
    });

    test('loads 5 mock notifications on init', () {
      expect(controller.notifications.length, 5);
    });

    test('unreadCount reflects initial unread notifications', () {
      final expectedUnread =
          controller.notifications.where((n) => !n.isRead).length;
      expect(controller.unreadCount.value, expectedUnread);
    });

    test('markAsRead decrements unreadCount', () {
      final unreadBefore = controller.unreadCount.value;
      final unreadItem =
          controller.notifications.firstWhere((n) => !n.isRead);

      controller.markAsRead(unreadItem.id);

      expect(controller.unreadCount.value, unreadBefore - 1);
    });

    test('markAllAsRead sets unreadCount to 0', () {
      controller.markAllAsRead();
      expect(controller.unreadCount.value, 0);
    });

    test('markAsRead on already-read item does not change count', () {
      controller.markAllAsRead();
      final countBefore = controller.unreadCount.value;

      controller.markAsRead(controller.notifications.first.id);

      expect(controller.unreadCount.value, countBefore);
    });

    test('timeAgo returns minutes for recent items', () {
      final result =
          controller.timeAgo(DateTime.now().subtract(const Duration(minutes: 3)));
      expect(result, '3m ago');
    });

    test('timeAgo returns hours for older items', () {
      final result =
          controller.timeAgo(DateTime.now().subtract(const Duration(hours: 2)));
      expect(result, '2h ago');
    });

    test('timeAgo returns days for old items', () {
      final result =
          controller.timeAgo(DateTime.now().subtract(const Duration(days: 3)));
      expect(result, '3d ago');
    });
  });
}
