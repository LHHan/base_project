import 'package:base_project_getx/app/data/providers/user_provider.dart';
import 'package:get/get.dart';

import '../../../data/models/user_model.dart';

class IsolateController extends GetxController {
  final _userProvider = Get.find<UserProvider>();

  var users = <UserModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchUsersData() async {
    isLoading.value = true;

    List<UserModel> parsedUsers = await _userProvider.getUsers();

    users.assignAll(parsedUsers);
    isLoading.value = false;
  }
}
