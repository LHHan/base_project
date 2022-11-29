/* Define app helper. Provide util function such as show popup, toast, flush bar, orientation mode */
class AppHelper {
  static final AppHelper _singleton = AppHelper._internal();

  factory AppHelper() {
    return _singleton;
  }

  AppHelper._internal();

  /// Check password
  static bool passwordValidator(String password) {
    // final RegExp passwordRegExp = RegExp(
    //     r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
    final RegExp passwordRegExp =
        RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$");

    if (password.isEmpty || !passwordRegExp.hasMatch(password)) {
      return false;
    }

    return true;
  }
}
