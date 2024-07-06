import 'hand_main_log_message.dart';
import 'package:fixnum/fixnum.dart';
// import 'package:logger/logger.dart';

// // debug usage
// var logger = Logger(
//   printer: PrettyPrinter(),
// );

class HandMainLogParser {
  HandMainLogLevel parseLogLevel(String log) {
    switch (log[0]) {
      case 'E':
        return HandMainLogLevel.error;
      case 'W':
        return HandMainLogLevel.warn;
      case 'I':
        return HandMainLogLevel.info;
      case 'D':
        return HandMainLogLevel.debug;
      case 'V':
        return HandMainLogLevel.verbose;
      default:
        return HandMainLogLevel.info;
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
      Int64 timestamp = Int64.parseInt(match.group(1)!);
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
        timestamp: Int64(0),
        level: level,
        source: 'unknown',
      );
    }
  }
}
