import 'package:base_project_getx/app/core/utils/app_const.dart';
import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:base_project_getx/app/data/models/user_model.dart';
import 'package:base_project_getx/app/widgets/p_appbar_transparency.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return PAppbarTransparency(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Text('Chats', style: Get.textTheme.tsPageName),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.contacts.isEmpty) {
                    return const Center(child: Text('No contacts found'));
                  }
                  return ListView.separated(
                    padding: EdgeInsets.only(
                      bottom:
                          AppConstant().kBottomNavigationBarHeight.toDouble(),
                    ),
                    itemCount: controller.contacts.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 0,
                      indent: 76,
                    ),
                    itemBuilder: (context, index) {
                      final user = controller.contacts[index];
                      return _ContactTile(
                        user: user,
                        lastMessage: controller.lastMessage(user.id),
                        lastTime: controller.lastTime(user.id),
                        hasUnread: controller.hasUnread(user.id),
                        unreadCount: controller.unreadCount(user.id),
                        isOnline: controller.isOnline(user.id),
                        onTap: () => controller.onTapContact(user),
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

// -----------------------------------------------------------------------------

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.user,
    required this.lastMessage,
    required this.lastTime,
    required this.hasUnread,
    required this.unreadCount,
    required this.isOnline,
    required this.onTap,
  });

  final UserModel user;
  final String lastMessage;
  final String lastTime;
  final bool hasUnread;
  final int unreadCount;
  final bool isOnline;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(user.image),
                  onBackgroundImageError: (_, __) {},
                ),
                if (isOnline)
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Get.theme.scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            12.horizontalSpace,

            // Name + last message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: Get.textTheme.tsBody.copyWith(
                      fontWeight:
                          hasUnread ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    lastMessage,
                    style: Get.textTheme.tsSubTitle.copyWith(
                      fontWeight:
                          hasUnread ? FontWeight.w600 : FontWeight.normal,
                      color: hasUnread
                          ? Get.theme.colorScheme.onSurface
                          : Get.theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            10.horizontalSpace,

            // Time + unread badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  lastTime,
                  style: Get.textTheme.tsChip.copyWith(
                    color: hasUnread
                        ? Get.theme.colorScheme.primary
                        : Get.theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                6.verticalSpace,
                if (hasUnread)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$unreadCount',
                      style: TextStyle(
                        color: Get.theme.colorScheme.onPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
