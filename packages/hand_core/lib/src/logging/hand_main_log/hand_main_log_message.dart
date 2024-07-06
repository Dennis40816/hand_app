import 'dart:ffi';
import 'package:fixnum/fixnum.dart';

class HandMainLogMessage {
  final String message;
  final String source;
  final Int64 timestamp;
  final HandMainLogLevel level;

  HandMainLogMessage({
    required this.message,
    required this.source,
    required this.timestamp,
    required this.level,
  });
}

enum HandMainLogLevel { info, warn, error, debug, verbose }
