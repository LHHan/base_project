import 'package:base_project_getx/app/modules/isolate/controllers/isolate_controller.dart';
import 'package:base_project_getx/app/widgets/p_material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

base class WSegmentProducts extends GetView<IsolateController> {
  const WSegmentProducts({super.key});

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
                itemCount: controller.filterProductsData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.filterProductsData[index].title),
                    subtitle:
                        Text("\$${controller.filterProductsData[index].price}"),
                    leading: Image.network(
                      controller.filterProductsData[index].thumbnail,
                    ),
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
