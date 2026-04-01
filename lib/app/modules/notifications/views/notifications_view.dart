import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:base_project_getx/app/widgets/p_appbar_transparency.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_const.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PAppbarTransparency(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifications',
                      style: Get.textTheme.tsPageName,
                    ),
                    Obx(() {
                      if (controller.unreadCount.value == 0) {
                        return const SizedBox.shrink();
                      }
                      return TextButton(
                        onPressed: controller.markAllAsRead,
                        child: Text(
                          'Mark all read',
                          style: Get.textTheme.tsBody.copyWith(
                            color: Get.theme.colorScheme.primary,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              8.verticalSpace,
              Expanded(
                child: Obx(() {
                  if (controller.notifications.isEmpty) {
                    return const Center(child: Text('No notifications'));
                  }
                  return ListView.separated(
                    padding: EdgeInsets.only(
                      bottom: AppConstant().kBottomNavigationBarHeight.toDouble(),
                    ),
                    itemCount: controller.notifications.length,
                    separatorBuilder: (_, __) => const Divider(height: 0),
                    itemBuilder: (context, index) {
                      final item = controller.notifications[index];
                      return _NotificationTile(
                        item: item,
                        timeLabel: controller.timeAgo(item.createdAt),
                        onTap: () => controller.markAsRead(item.id),
                      );
                    },
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

class _NotificationTile extends StatelessWidget {
  final NotificationItem item;
  final String timeLabel;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.item,
    required this.timeLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: item.isRead
            ? Colors.transparent
            : Get.theme.colorScheme.primary.withValues(alpha: 0.08),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                size: 22,
                color: Get.theme.colorScheme.primary,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.title,
                        style: Get.textTheme.tsBody.copyWith(
                          fontWeight:
                              item.isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      Text(
                        timeLabel,
                        style: Get.textTheme.tsChip,
                      ),
                    ],
                  ),
                  4.verticalSpace,
                  Text(
                    item.message,
                    style: Get.textTheme.tsSubTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!item.isRead) ...[
              8.horizontalSpace,
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
