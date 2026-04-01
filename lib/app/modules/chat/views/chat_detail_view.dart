import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:base_project_getx/app/modules/chat/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/chat_detail_controller.dart';

class ChatDetailView extends GetView<ChatDetailController> {
  const ChatDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: Obx(() => ListView.builder(
                  controller: controller.scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    final prev = index > 0 ? controller.messages[index - 1] : null;
                    final showAvatar = !msg.isMe &&
                        (prev == null || prev.isMe);

                    return _MessageBubble(
                      message: msg,
                      showAvatar: showAvatar,
                      avatarUrl: controller.user.image,
                    );
                  },
                )),
          ),

          // Typing indicator
          Obx(() {
            if (!controller.isTyping.value) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(controller.user.image),
                    onBackgroundImageError: (_, __) {},
                  ),
                  10.horizontalSpace,
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) => _TypingDot(delay: i)),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Input bar
          _InputBar(
            textController: controller.textController,
            onSend: controller.sendMessage,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: Get.back,
      ),
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(controller.user.image),
                onBackgroundImageError: (_, __) {},
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Get.theme.scaffoldBackgroundColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          10.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${controller.user.firstName} ${controller.user.lastName}',
                style: Get.textTheme.tsBody
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                'Online',
                style: Get.textTheme.tsChip.copyWith(
                  color: const Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call_rounded),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.videocam_rounded),
          onPressed: () {},
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.showAvatar,
    required this.avatarUrl,
  });

  final ChatMessage message;
  final bool showAvatar;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final timeLabel = DateFormat('HH:mm').format(message.time);

    return Padding(
      padding: EdgeInsets.only(
        bottom: 4,
        left: isMe ? 48 : 0,
        right: isMe ? 0 : 48,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Their avatar
          if (!isMe) ...[
            if (showAvatar)
              CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(avatarUrl),
                onBackgroundImageError: (_, __) {},
              )
            else
              const SizedBox(width: 28),
            8.horizontalSpace,
          ],

          // Bubble
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width * 0.65,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isMe
                      ? Get.theme.colorScheme.primary
                      : Get.theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isMe ? 18 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 18),
                  ),
                ),
                child: Text(
                  message.text,
                  style: Get.textTheme.tsBody.copyWith(
                    color: isMe
                        ? Get.theme.colorScheme.onPrimary
                        : Get.theme.colorScheme.onSurface,
                    height: 1.4,
                  ),
                ),
              ),
              4.verticalSpace,
              Text(timeLabel, style: Get.textTheme.tsChip),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.textController,
    required this.onSend,
  });

  final TextEditingController textController;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: Get.theme.colorScheme.outlineVariant
                  .withValues(alpha: 0.4),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: textController,
                  textCapitalization: TextCapitalization.sentences,
                  style: Get.textTheme.tsBody,
                  maxLines: 4,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Message...',
                    hintStyle: Get.textTheme.tsSubTitle,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => onSend(),
                ),
              ),
            ),
            10.horizontalSpace,
            GestureDetector(
              onTap: onSend,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.send_rounded,
                  color: Get.theme.colorScheme.onPrimary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------

class _TypingDot extends StatefulWidget {
  const _TypingDot({required this.delay});
  final int delay;

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(widget.delay * 0.2, 1.0, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Container(
        width: 7,
        height: 7,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.onSurfaceVariant
              .withValues(alpha: 0.4 + 0.6 * _animation.value),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
