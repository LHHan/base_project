import 'package:base_project_getx/app/widgets/w_button_rounded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_style.dart';
import '../../../widgets/p_appbar_transparency.dart';
import '../controllers/setting_languages_controller.dart';
import '../widgets/w_languages_item.dart';

class SettingLanguagesView extends GetView<SettingLanguagesController> {
  const SettingLanguagesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PAppbarTransparency(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Page's name
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0).w,
            child: Text(
              'labelLanguages'.tr,
              style: AppStyles().mediumTextStyle(36.sp),
            ),
          ),

          50.verticalSpace,

          /// Page's content
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 70.h,
                  bottom: 0,
                  width: Get.width,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32.r),
                      ),
                      color: const ColorScheme.light().primary,
                    ),
                    padding: const EdgeInsets.fromLTRB(0, 80, 0, 30).h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /// List supported languages
                        Expanded(
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            primary: true,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 4.h,
                              crossAxisSpacing: 4.w,
                              mainAxisExtent: 140.h,
                            ),
                            padding:
                                const EdgeInsets.fromLTRB(16, 0, 16, 100).w,
                            itemCount: controller.dummyLanguages.length,
                            itemBuilder: (context, index) => GetBuilder(
                              id: 'idLanguagesItem_$index',
                              init: controller,
                              builder: (_) {
                                return WLanguagesItem(
                                  language: controller.dummyLanguages[index],
                                  isSelected:
                                      controller.selectedLang.value.id !=
                                              null &&
                                          controller.dummyLanguages[index].id ==
                                              controller.selectedLang.value.id,
                                  onPressed: () => controller.onSelectLanguage(
                                    indexLang: index,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Current languages
                Positioned(
                  child: CircleAvatar(
                    maxRadius: 70.r,
                    backgroundColor: Colors.black12.withValues(alpha: 0.1),
                    child: CircleAvatar(
                      maxRadius: 55.r,
                      backgroundColor: Colors.black12.withValues(alpha: 0.1),
                      child: CircleAvatar(
                        maxRadius: 45.r,
                        backgroundColor: Colors.white54,
                        child: ClipOval(
                          child: Obx(
                            () => controller.selectedLang.value.langFlag != null
                                ? SvgPicture.network(
                                    controller.selectedLang.value.langFlag ??
                                        '',
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// Confirm button
                Positioned(
                  bottom: 50,
                  child: SizedBox(
                    width: 200.w,
                    height: 45.h,
                    child: WButtonRounded(
                      background: const ColorScheme.light().surface,
                      onPressed: controller.onPressedOKButton,
                      child: Text(
                        'OK',
                        style: AppStyles().semiBoldTextStyle(20.sp,
                            color: const ColorScheme.light().primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
