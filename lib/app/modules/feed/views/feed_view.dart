import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:base_project_getx/app/data/models/product_model.dart';
import 'package:base_project_getx/app/widgets/p_appbar_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_const.dart';
import '../controllers/feed_controller.dart';

class FeedView extends GetView<FeedController> {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return PAppbarTransparency(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8).w,
                child: Text(
                  'Feed',
                  style: Get.textTheme.tsPageName,
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.products.isEmpty) {
                    return const Center(child: Text('No products found'));
                  }
                  return RefreshIndicator(
                    onRefresh: controller.onRefresh,
                    child: GridView.builder(
                      padding: EdgeInsets.fromLTRB(
                              12, 8, 12, AppConstant().kBottomNavigationBarHeight.toDouble())
                          .w,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: controller.products.length,
                      itemBuilder: (context, index) {
                        return _ProductCard(product: controller.products[index]);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              product.thumbnail,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (_, __, ___) =>
                  const Center(child: Icon(Icons.image_not_supported)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8).w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: Get.textTheme.tsBody,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                4.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: Get.textTheme.tsLabel.copyWith(
                        color: Get.theme.colorScheme.primary,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14.r, color: Colors.amber),
                        4.horizontalSpace,
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: Get.textTheme.tsChip,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
