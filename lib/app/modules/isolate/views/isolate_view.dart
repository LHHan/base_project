import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:base_project_getx/app/modules/isolate/widgets/w_segment_products.dart';
import 'package:base_project_getx/app/widgets/w_keep_alive.dart';
import 'package:base_project_getx/app/widgets/w_keyboard_dismiss.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../widgets/p_appbar_transparency.dart';
import '../controllers/isolate_controller.dart';
import '../widgets/w_segment_users.dart';

class IsolateView extends GetView<IsolateController> {
  const IsolateView({super.key});

  @override
  Widget build(BuildContext context) {
    return PAppbarTransparency(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Obx(
            () => CupertinoSegmentedControl<int>(
              children: {
                0: Padding(
                  padding: EdgeInsets.all(8).r,
                  child: Text(
                    "Users",
                    style: Get.textTheme.tsTitle,
                  ),
                ),
                1: Padding(
                  padding: EdgeInsets.all(8).r,
                  child: Text(
                    "Products",
                    style: Get.textTheme.tsTitle,
                  ),
                ),
              },
              onValueChanged: (int value) =>
                  controller.onChangedSegment(segment: value),
              groupValue: controller.selectedSegment.value,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CupertinoSearchTextField(
                onChanged: (value) => controller.onSearchData(query: value),
                onSubmitted: (value) => controller.onSearchData(query: value),
              ),
            ),
          ),
        ),
        child: WKeyboardDismiss(
          child: SafeArea(
            child: Obx(() => _buildSegmentContent()),
          ),
        ),
      ),
    );
  }
 
  Widget _buildSegmentContent() {
    switch (controller.selectedSegment.value) {
      case 1:
        return WKeepAlive(child: WSegmentProducts());
      default:
        return WKeepAlive(child: WSegmentUsers());
    }
  }
}
