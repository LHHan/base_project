import 'package:base_project_getx/my_app.dart';

import 'app/core/themes/app_theme.dart';
import 'app/core/utils/app_config.dart';

Future<void> main() async {
  /// Init dev config
  AppConfig(env: Env.dev(), theme: AppTheme.origin());
  await myMain();
}
