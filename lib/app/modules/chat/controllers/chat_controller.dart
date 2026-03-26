import 'package:base_project_getx/app/data/models/user_model.dart';
import 'package:base_project_getx/app/data/providers/user_provider.dart';
import 'package:base_project_getx/app/services/rest_api_safety.dart';
import 'package:get/get.dart';

class ChatController extends GetxController with RestApiSafety {
  ChatController({required UserProvider userProvider})
      : _userProvider = userProvider;

  final UserProvider _userProvider;

  var contacts = <UserModel>[].obs;
  var isLoading = false.obs;

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
    // TODO: Navigate to chat detail screen
  }
}
