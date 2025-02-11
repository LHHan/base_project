import 'package:base_project_getx/app/widgets/w_button_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../core/utils/app_colors.dart';
import '../core/utils/app_config.dart';
import 'p_material.dart';

class PAppBarTransparency extends StatelessWidget {
  const PAppBarTransparency(
      {this.body,
      this.child,
      this.forceStatusIconLight,
      this.forceHideBackButton = false,
      this.backButton,
      Key? key})
      : super(key: key);

  final Widget? child;
  final Widget? body;
  final bool? forceStatusIconLight;
  final bool? forceHideBackButton;
  final Positioned? backButton;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Get.isDarkMode ? AppConfig.I.theme.dark : AppConfig.I.theme.light;
    final SystemUiOverlayStyle uiOverlayStyle = forceStatusIconLight == true
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    return PMaterial(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: uiOverlayStyle.copyWith(statusBarColor: Colors.transparent),
        child: body ??
            Stack(
              children: [
                Scaffold(
                  backgroundColor: theme.colorScheme.surface,
                  body: SafeArea(
                    bottom: false,
                    child: child ?? const SizedBox(),
                  ),
                ),
                if (Navigator.canPop(context) && forceHideBackButton != true)
                  backButton ??
                      Positioned(
                        top: 40.h,
                        left: 16.w,
                        child: WButtonInkwell(
                          onPressed: () => Get.back(),
                          borderRadius: BorderRadius.circular(40.r),
                          child: Padding(
                            padding: const EdgeInsets.all(20).r,
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: AppColors().colorPrimary,
                              size: 28.r,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
      ),
    );
  }
}
