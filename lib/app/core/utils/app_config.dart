/* Define app config multi environment */
import 'app_enum.dart';
import 'app_theme.dart';

/// Environment declare here
class Env {
  Env._({
    required this.envType,
    required this.apiBaseUrl,
  });

  /// Dev mode (native flavor `dev`).
  ///
  /// Override base URL at compile time, in order of precedence:
  /// - `--dart-define=API_BASE_URL=https://...` (applies to any flavor)
  /// - `--dart-define=API_BASE_URL_DEV=https://...`
  /// - default `https://api.dev`
  factory Env.dev() {
    return Env._(
      envType: EnvType.dev,
      apiBaseUrl: _resolveApiBaseUrl(
        flavorDefault: const String.fromEnvironment(
          'API_BASE_URL_DEV',
          defaultValue: 'https://api.dev',
        ),
      ),
    );
  }

  /// Prod mode (native flavor `prod`).
  ///
  /// Same as [Env.dev], with `API_BASE_URL_PROD` as the flavor default key.
  factory Env.prod() {
    return Env._(
      envType: EnvType.prod,
      apiBaseUrl: _resolveApiBaseUrl(
        flavorDefault: const String.fromEnvironment(
          'API_BASE_URL_PROD',
          defaultValue: 'https://api.prod',
        ),
      ),
    );
  }

  final EnvType envType;
  final String apiBaseUrl;
}

/// Global override wins over per-flavor defaults.
String _resolveApiBaseUrl({required String flavorDefault}) {
  const String override =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');
  if (override.isNotEmpty) {
    return override;
  }
  return flavorDefault;
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
