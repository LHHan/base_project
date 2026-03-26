import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:base_project_getx/app/widgets/p_appbar_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_const.dart';
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12).w,
                child: Text(
                  'Chats',
                  style: Get.textTheme.tsPageName,
                ),
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
                      bottom: AppConstant().kBottomNavigationBarHeight.toDouble().h,
                    ),
                    itemCount: controller.contacts.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 0, indent: 72),
                    itemBuilder: (context, index) {
                      final user = controller.contacts[index];
                      return ListTile(
                        onTap: () => controller.onTapContact(user),
                        leading: CircleAvatar(
                          radius: 24.r,
                          backgroundImage: NetworkImage(user.image),
                          onBackgroundImageError: (_, __) {},
                        ),
                        title: Text(
                          '${user.firstName} ${user.lastName}',
                          style: Get.textTheme.tsBody,
                        ),
                        subtitle: Text(
                          user.email,
                          style: Get.textTheme.tsSubTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          '12:00',
                          style: Get.textTheme.tsChip,
                        ),
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
