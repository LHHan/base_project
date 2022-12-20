/* Define app helper. Provide util function such as show popup, toast, flush bar, orientation mode */

class AppHelper {
  static final AppHelper _singleton = AppHelper._internal();

  factory AppHelper() {
    return _singleton;
  }

  AppHelper._internal();
}
