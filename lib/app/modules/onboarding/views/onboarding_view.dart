import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: Obx(() {
                if (controller.isLastPage) return const SizedBox.shrink();
                return TextButton(
                  onPressed: controller.skip,
                  child: Text('Skip', style: Get.textTheme.tsBody),
                );
              }),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPageWidget(
                    page: controller.pages[index],
                  );
                },
              ),
            ),

            // Dots indicator
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4).w,
                      width: controller.currentPage.value == index ? 24.w : 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: controller.currentPage.value == index
                            ? controller.pages[index].color
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                )),

            32.verticalSpace,

            // Next / Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24).w,
              child: Obx(() => SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: controller.nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.pages[controller.currentPage.value].color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        controller.isLastPage ? "Get Started" : "Next",
                        style: Get.textTheme.tsButton,
                      ),
                    ),
                  )),
            ),

            24.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const _OnboardingPageWidget({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32).w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160.r,
            height: 160.r,
            decoration: BoxDecoration(
              color: page.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 80.r,
              color: page.color,
            ),
          ),
          40.verticalSpace,
          Text(
            page.title,
            style: Get.textTheme.tsPageName,
            textAlign: TextAlign.center,
          ),
          16.verticalSpace,
          Text(
            page.description,
            style: Get.textTheme.tsSubTitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
