import '../models/hand/hand_log_message.dart';

class HandLogParser {
  HandLogParser();

  /// Removes ANSI escape codes from the log string.
  String removeAnsiCodes(String log) {
    final ansiEscapeCodes = RegExp(r'\x1B\[[0-?]*[ -/]*[@-~]');
    return log.replaceAll(ansiEscapeCodes, '');
  }

  /// Parses a log string into a HandLogMessage.
  HandLogMessage parseLog(String log) {
    String cleanedLog = removeAnsiCodes(log);

    HandLogLevel level = parseLogLevel(cleanedLog);
    RegExp regex = RegExp(r'\((\d+)\) ([^:]+): (.+)');
    Match? match = regex.firstMatch(cleanedLog);

    if (match != null) {
      int timestamp = int.parse(match.group(1)!);
      String source = match.group(2)!;
      String message = match.group(3)!;

      return HandLogMessage(
        message: message,
        timestamp: timestamp,
        level: level,
        source: source,
      );
    } else {
      return HandLogMessage(
        message: cleanedLog,
        timestamp: 0,
        level: level,
        source: 'unknown',
      );
    }
  }

  /// Parses the log level from the log string.
  HandLogLevel parseLogLevel(String log) {
    if (log.startsWith('E')) {
      return HandLogLevel.error;
    } else if (log.startsWith('W')) {
      return HandLogLevel.warning;
    } else if (log.startsWith('I')) {
      return HandLogLevel.info;
    } else if (log.startsWith('D')) {
      return HandLogLevel.debug;
    } else if (log.startsWith('V')) {
      return HandLogLevel.verbose;
    } else {
      return HandLogLevel.info;
    }
  }
}
