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
  String icAppIcon = 'assets/app/icons/ic_app_icon.png';
  String icEmpty = 'assets/app/icons/ic_empty.png';

  /// #region Image, Video
  /// -----------------
  String imFlagVi = 'assets/app/images/im_flag_vi.png';
  String imFlagEn = 'assets/app/images/im_flag_us.png';
}
