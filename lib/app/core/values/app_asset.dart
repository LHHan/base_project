class AppAssets {
  static final AppAssets _singleton = AppAssets._internal();

  factory AppAssets() {
    return _singleton;
  }

  AppAssets._internal();

  /// #region Font
  /// -----------------
  String fontRoboto = 'Roboto';
  String fontLato = 'Lato';

  /// #region Icon
  /// -----------------
  String icAppIcon = 'assets/base/icons/ic_app_icon.png';
  String icEmpty = 'assets/base/icons/ic_empty.png';

  /// #region Image, Video
  /// -----------------

}
