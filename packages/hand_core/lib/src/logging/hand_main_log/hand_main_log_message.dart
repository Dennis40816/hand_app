import '../../model/log_message_interface.dart';

enum HandMainLogLevelType { info, warn, error, debug, verbose }

class HandMainLogLevel implements LogLevel {
  final HandMainLogLevelType type;

  HandMainLogLevel(this.type);

  @override
  String getLevelString() {
    switch (type) {
      case HandMainLogLevelType.error:
        return "ERROR";
      case HandMainLogLevelType.warn:
        return "WARN";
      case HandMainLogLevelType.info:
        return "INFO";
      case HandMainLogLevelType.debug:
        return "DEBUG";
      case HandMainLogLevelType.verbose:
        return "VERBOSE";
      default:
        return "INFO";
    }
  }
}

class HandMainLogMessage implements LogMessage<HandMainLogLevel> {
  @override
  final String message;
  @override
  final String source;
  @override
  final int timestamp;
  @override
  final HandMainLogLevel level;

  HandMainLogMessage({
    required this.message,
    required this.source,
    required this.timestamp,
    required this.level,
  });

  @override
  String getLevelString() {
    return level.getLevelString();
  }
}
