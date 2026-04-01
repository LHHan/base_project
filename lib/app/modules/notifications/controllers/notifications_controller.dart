import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationItem {
  final int id;
  final String title;
  final String message;
  final DateTime createdAt;
  final IconData icon;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.icon,
    this.isRead = false,
  });
}

class NotificationsController extends GetxController {
  var notifications = <NotificationItem>[].obs;
  var unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockNotifications();
  }

  void _loadMockNotifications() {
    final now = DateTime.now();
    notifications.assignAll([
      NotificationItem(
        id: 1,
        title: 'Welcome!',
        message: 'Thanks for joining. Explore the app and enjoy!',
        createdAt: now.subtract(const Duration(minutes: 5)),
        icon: Icons.waving_hand,
        isRead: false,
      ),
      NotificationItem(
        id: 2,
        title: 'New message',
        message: 'You have a new message from John Doe.',
        createdAt: now.subtract(const Duration(hours: 1)),
        icon: Icons.chat_bubble_outline,
        isRead: false,
      ),
      NotificationItem(
        id: 3,
        title: 'Update available',
        message: 'A new version of the app is available. Update now!',
        createdAt: now.subtract(const Duration(hours: 3)),
        icon: Icons.system_update_outlined,
        isRead: true,
      ),
      NotificationItem(
        id: 4,
        title: 'Profile incomplete',
        message: 'Complete your profile to unlock all features.',
        createdAt: now.subtract(const Duration(days: 1)),
        icon: Icons.person_outline,
        isRead: true,
      ),
      NotificationItem(
        id: 5,
        title: 'Flash sale!',
        message: 'Enjoy up to 50% off on selected products today only.',
        createdAt: now.subtract(const Duration(days: 2)),
        icon: Icons.local_offer_outlined,
        isRead: true,
      ),
    ]);
    _updateUnreadCount();
  }

  void markAsRead(int id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index].isRead = true;
      notifications.refresh();
      _updateUnreadCount();
    }
  }

  void markAllAsRead() {
    for (final n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
    unreadCount.value = 0;
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  String timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
