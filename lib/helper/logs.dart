enum LogLevel { debug, info, error }

class Logs {
  // Set to true in debug, false in prod
  static bool _isDebug = true;

  static void init({required bool isDebug}) {
    _isDebug = isDebug;
  }

  static void debug(String message) {
    if (_isDebug) {
      _log(LogLevel.debug, message);
    }
  }

  static void info(String message) {
    _log(LogLevel.info, message);
  }

  static void error(String message, [Exception? e]) {
    _log(LogLevel.error, message, e);
  }

  static void _log(LogLevel level, String message, [Exception? e]) {
    final logMessage = '[${level.name.toUpperCase()}] $message';
    if (_isDebug || level != LogLevel.debug) {
      if (e != null) {
        // Print with exception details in debug
        print('$logMessage \nException: $e');
      } else {
        print(logMessage);
      }
    }
    // TODO: Optionally send errors to external logging service in prod
  }
}
