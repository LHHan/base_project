import 'package:base_project_getx/app/modules/isolate/controllers/isolate_controller.dart';
import 'package:base_project_getx/app/widgets/p_material.dart';
import 'package:base_project_getx/app/widgets/w_keep_alive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

base class WSegmentUsers extends GetView<IsolateController> {
  const WSegmentUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return PMaterial(
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: controller.filterUsersData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.filterUsersData[index].name),
                    subtitle:
                        Text("ID: ${controller.filterUsersData[index].id}"),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
