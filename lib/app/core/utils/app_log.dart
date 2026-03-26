import 'package:logger/logger.dart';

/// Application logger.
///
/// Behavior by build mode:
/// - **Debug**: logs everything (info, warning, error, verbose)
/// - **Release**: logs only [Level.warning] and above — info/verbose are silenced
///
/// Usage:
/// ```dart
/// logger.i('User logged in');       // info
/// logger.w('Token expiring soon');  // warning
/// logger.e('API call failed', error: e, stackTrace: s); // error
/// ```
final Logger logger = Logger(
  filter: ProductionFilter(),
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.none,
  ),
);
