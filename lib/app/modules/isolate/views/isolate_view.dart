import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/p_appbar_transparency.dart';
import '../../../widgets/w_button_rounded.dart';
import '../controllers/isolate_controller.dart';

class IsolateView extends GetView<IsolateController> {
  const IsolateView({super.key});

  @override
  Widget build(BuildContext context) {
    return PAppbarTransparency(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WButtonRounded(
              onPressed: controller.fetchUsersData, // Gọi hàm tải dữ liệu
              elevation: 4,
              child: Text(
                "Tải dữ liệu",
                style: Get.textTheme.tsButton,
              ),
            ),

            /// Data
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.users[index].name),
                      subtitle: Text("ID: ${controller.users[index].id}"),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
