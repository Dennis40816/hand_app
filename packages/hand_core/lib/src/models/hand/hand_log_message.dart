enum HandLogLevel {
  error,
  warning,
  info,
  debug,
  verbose,
}

class HandLogMessage {
  final int timestamp;
  final HandLogLevel level;
  final String source;
  final String message;

  HandLogMessage({
    required this.timestamp,
    required this.level,
    required this.source,
    required this.message,
  });

  @override
  String toString() {
    String levelStr;
    switch (level) {
      case HandLogLevel.error:
        levelStr = 'ERROR';
        break;
      case HandLogLevel.warning:
        levelStr = 'WARNING';
        break;
      case HandLogLevel.info:
        levelStr = 'INFO';
        break;
      case HandLogLevel.debug:
        levelStr = 'DEBUG';
        break;
      case HandLogLevel.verbose:
      default:
        levelStr = 'VERBOSE';
        break;
    }
    return '$levelStr ($timestamp) [$source]: $message';
  }
}
