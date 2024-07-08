import 'hand_main_log_message.dart';
// import 'package:logger/logger.dart';

// // debug usage
// var logger = Logger(
//   printer: PrettyPrinter(),
// );

class HandMainLogParser {
  HandMainLogLevel parseLogLevel(String log) {
    switch (log[0]) {
      case 'E':
        return HandMainLogLevel(HandMainLogLevelType.error);
      case 'W':
        return HandMainLogLevel(HandMainLogLevelType.warn);
      case 'I':
        return HandMainLogLevel(HandMainLogLevelType.info);
      case 'D':
        return HandMainLogLevel(HandMainLogLevelType.debug);
      case 'V':
        return HandMainLogLevel(HandMainLogLevelType.verbose);
      default:
        return HandMainLogLevel(HandMainLogLevelType.info);
    }
  }

  String removeAnsiCodes(String log) {
    final ansiEscapeCodes = RegExp(r'\x1B\[[0-?]*[ -/]*[@-~]');
    return log.replaceAll(ansiEscapeCodes, '');
  }

  HandMainLogMessage parseLog(String log) {
    String cleanedLog = removeAnsiCodes(log);

    HandMainLogLevel level = parseLogLevel(cleanedLog);
    RegExp regex = RegExp(r'\((\d+)\) ([^:]+): (.+)');
    Match? match = regex.firstMatch(cleanedLog);

    if (match != null) {
      int timestamp = int.parse(match.group(1)!);
      String source = match.group(2)!;
      String message = match.group(3)!;

      // // debug usage
      // logger.d("got $cleanedLog");

      return HandMainLogMessage(
        message: message,
        timestamp: timestamp,
        level: level,
        source: source,
      );
    } else {
      return HandMainLogMessage(
        message: cleanedLog,
        timestamp: 0,
        level: level,
        source: 'unknown',
      );
    }
  }
}
