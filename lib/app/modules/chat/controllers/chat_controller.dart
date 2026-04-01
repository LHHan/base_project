import 'package:base_project_getx/app/data/models/user_model.dart';
import 'package:base_project_getx/app/data/providers/user_provider.dart';
import 'package:base_project_getx/app/routes/app_pages.dart';
import 'package:base_project_getx/app/services/rest_api_safety.dart';
import 'package:get/get.dart';

class ChatController extends GetxController with RestApiSafety {
  ChatController({required UserProvider userProvider})
      : _userProvider = userProvider;

  final UserProvider _userProvider;

  var contacts = <UserModel>[].obs;
  var isLoading = false.obs;

  // Mock last messages per contact (deterministic from userId)
  static const _lastMessages = [
    'Hey! How are you? 👋',
    'Did you see the update?',
    'Let\'s catch up soon!',
    'Thanks for your help 🙏',
    'Are you free tomorrow?',
    'Just finished the project 🎉',
    'Have you tried that new café?',
    'Great work today!',
    'On my way!',
    'Sounds good 👍',
  ];

  static const _lastTimes = [
    '2m', '15m', '32m', '1h', '2h', '3h', 'Yesterday', 'Mon', 'Sun', 'Sat',
  ];

  String lastMessage(int userId) =>
      _lastMessages[userId % _lastMessages.length];

  String lastTime(int userId) => _lastTimes[userId % _lastTimes.length];

  bool hasUnread(int userId) => userId % 3 == 0;

  int unreadCount(int userId) => (userId % 4) + 1;

  bool isOnline(int userId) => userId % 2 == 0;

  @override
  void onReady() {
    super.onReady();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    await apiCallSafety(
      () => _userProvider.getUsers(),
      onStart: () async => isLoading.value = true,
      onCompleted: (status, res) async {
        if (status && res != null) contacts.assignAll(res);
        isLoading.value = false;
      },
    );
  }

  void onTapContact(UserModel user) {
    Get.toNamed(Routes.CHAT_DETAIL, arguments: user);
  }
}
