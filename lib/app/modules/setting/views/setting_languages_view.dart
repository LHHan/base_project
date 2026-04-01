import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:base_project_getx/app/widgets/w_button_rounded.dart';
import 'package:flutter/material.dart';
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
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Text(
              'labelLanguages'.tr,
              style: AppStyles().mediumTextStyle(36),
            ),
          ),

          50.verticalSpace,

          /// Page's content
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 70,
                  bottom: 0,
                  width: Get.width,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                      color: const ColorScheme.light().primary,
                    ),
                    padding: const EdgeInsets.fromLTRB(0, 80, 0, 30),
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
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              mainAxisExtent: 140,
                            ),
                            padding:
                                const EdgeInsets.fromLTRB(16, 0, 16, 100),
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
                    maxRadius: 70,
                    backgroundColor: Colors.black12.withValues(alpha: 0.1),
                    child: CircleAvatar(
                      maxRadius: 55,
                      backgroundColor: Colors.black12.withValues(alpha: 0.1),
                      child: CircleAvatar(
                        maxRadius: 45,
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
                    width: 200,
                    height: 45,
                    child: WButtonRounded(
                      background: const ColorScheme.light().surface,
                      onPressed: controller.onPressedOKButton,
                      child: Text(
                        'OK',
                        style: AppStyles().semiBoldTextStyle(20,
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
