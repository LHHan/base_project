import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/p_appbar_transparency.dart';
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
            ElevatedButton(
              onPressed: controller.fetchUsersData, // Gọi hàm tải dữ liệu
              child: const Text("Tải dữ liệu"),
            ),
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
