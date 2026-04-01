import 'package:base_project_getx/app/data/models/user_model.dart';
import 'package:base_project_getx/app/modules/chat/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatDetailController extends GetxController {
  late final UserModel user;

  final messages = <ChatMessage>[].obs;
  final textController = TextEditingController();
  final scrollController = ScrollController();
  final isTyping = false.obs;

  static const _mockConversations = [
    [
      ('Hey! How are you doing? 👋', false),
      ('I\'m great, thanks! Just got back from a walk.', true),
      ('Nice! The weather\'s been amazing lately ☀️', false),
      ('Right? Perfect time for it. You should join next time!', true),
      ('I\'d love that! When are you usually free?', false),
    ],
    [
      ('Did you check out the new update?', false),
      ('Not yet, what\'s new in it?', true),
      ('They completely redesigned the dashboard. Looks clean!', false),
      ('Oh nice, I\'ll have a look later today.', true),
      ('You\'ll love it. Way faster too.', false),
    ],
    [
      ('Are you coming to the meeting tomorrow?', false),
      ('Yes, I\'ll be there at 10.', true),
      ('Great! Don\'t forget to bring the report.', false),
      ('Already on it 👍', true),
      ('Perfect. See you then!', false),
    ],
    [
      ('Just finished the project 🎉', true),
      ('Already?! That was fast!', false),
      ('Haha, had a good flow today.', true),
      ('Well deserved break time then!', false),
      ('Absolutely. Coffee first 😄', true),
    ],
    [
      ('Have you tried that new café downtown?', false),
      ('Not yet! Is it good?', true),
      ('Amazing lattes and super cozy vibes 🫶', false),
      ('Adding it to my list for the weekend.', true),
      ('Let me know what you think!', false),
    ],
  ];

  static const _autoReplies = [
    'Sounds good! 👍',
    'Got it, thanks!',
    'Interesting! Tell me more.',
    'Haha, true that 😄',
    'Let\'s do it!',
    'On it!',
    'Makes sense.',
    'Absolutely!',
    'Cool 😎',
    'I\'ll think about it.',
  ];

  @override
  void onInit() {
    super.onInit();
    user = Get.arguments as UserModel;
    _loadMockMessages();
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _loadMockMessages() {
    final conversation =
        _mockConversations[user.id % _mockConversations.length];
    final now = DateTime.now();

    messages.assignAll(
      conversation.indexed.map((entry) {
        final (i, item) = entry;
        return ChatMessage(
          id: '${user.id}_$i',
          text: item.$1,
          isMe: item.$2,
          time: now.subtract(Duration(minutes: (conversation.length - i) * 4)),
        );
      }),
    );
  }

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isMe: true,
      time: DateTime.now(),
    ));
    textController.clear();
    _scrollToBottom();

    // Simulate typing + reply
    isTyping.value = true;
    Future.delayed(const Duration(milliseconds: 900), () {
      isTyping.value = false;
      messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: _autoReplies[messages.length % _autoReplies.length],
        isMe: false,
        time: DateTime.now(),
      ));
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
