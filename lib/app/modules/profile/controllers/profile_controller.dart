import 'package:base_project_getx/app/data/models/user_model.dart';
import 'package:base_project_getx/app/data/providers/user_provider.dart';
import 'package:base_project_getx/app/services/rest_api_safety.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController with RestApiSafety {
  ProfileController({required UserProvider userProvider})
      : _userProvider = userProvider;

  final UserProvider _userProvider;

  var user = Rxn<UserModel>();
  var isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    await apiCallSafety(
      () => _userProvider.getUsers(),
      onStart: () async => isLoading.value = true,
      onCompleted: (status, res) async {
        if (status && res != null && res.isNotEmpty) {
          user.value = res.first;
        }
        isLoading.value = false;
      },
    );
  }
}
