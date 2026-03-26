import 'package:base_project_getx/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:base_project_getx/app/modules/onboarding/views/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

Widget _buildTestWidget() {
  return ScreenUtilInit(
    designSize: const Size(428, 926),
    child: GetMaterialApp(
      home: const OnboardingView(),
      initialBinding: BindingsBuilder(() {
        Get.put(OnboardingController());
      }),
    ),
  );
}

void main() {
  tearDown(() => Get.reset());

  group('OnboardingView', () {
    testWidgets('renders first page title', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pump();

      expect(find.text('Welcome'), findsOneWidget);
    });

    testWidgets('shows Skip button on first page', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pump();

      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('shows Next button on first page', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pump();

      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('tapping Next advances to second page', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pump();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('Stay Connected'), findsOneWidget);
    });

    testWidgets('shows Get Started on last page', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pump();

      final controller = Get.find<OnboardingController>();
      controller.pageController.jumpToPage(2);
      await tester.pumpAndSettle();

      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('Skip button hidden on last page', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pump();

      final controller = Get.find<OnboardingController>();
      controller.pageController.jumpToPage(2);
      await tester.pumpAndSettle();

      expect(find.text('Skip'), findsNothing);
    });

    testWidgets('page indicator dots match page count', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pump();

      final controller = Get.find<OnboardingController>();
      expect(controller.pages.length, 3);
    });
  });
}
