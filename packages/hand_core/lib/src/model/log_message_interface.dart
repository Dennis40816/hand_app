abstract class LogLevel {
  String getLevelString();
}

abstract class LogMessage<L extends LogLevel> {
  String get message;
  String get source;
  int get timestamp;
  L get level;

  String getLevelString();
  @override
  String toString() {
    return '${getLevelString()} ($timestamp) [$source] $message\n';
  }
}
