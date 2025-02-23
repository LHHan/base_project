/* Define app config multi environment */
import 'app_enum.dart';
import 'app_theme.dart';

/// Environment declare here
class Env {
  Env._({
    required this.envType,
    required this.apiBaseUrl,
  });

  /// Dev mode
  factory Env.dev() {
    return Env._(
      envType: EnvType.dev,
      apiBaseUrl: 'https://api.dev',
    );
  }

  /// Prod mode
  factory Env.prod() {
    return Env._(
      envType: EnvType.prod,
      apiBaseUrl: 'https://api.prod',
    );
  }

  final EnvType envType;
  final String apiBaseUrl;
}

/// Config env
class AppConfig {
  factory AppConfig({required Env env, AppTheme? theme}) {
    I.env = env;
    if (theme != null) {
      I.theme = theme;
    }
    return I;
  }

  AppConfig._private();

  static final AppConfig I = AppConfig._private();

  Env env = Env.dev();
  AppTheme theme = AppTheme();
}
