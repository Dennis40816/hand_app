import 'package:flutter/material.dart';
import 'package:hand_core/hand_core.dart';

class LogDataState<T extends LogMessage<L>, L extends LogLevel>
    with ChangeNotifier {
  final List<T> _logMessages = [];
  int _maxLines = 500;

  int get maxLines => _maxLines;
  List<T> get logMessages => _logMessages;

  void appendMessage(T message) {
    _logMessages.add(message);
    _removeExcessMessages();
    notifyListeners();
  }

  void _removeExcessMessages() {
    int excessCount = _logMessages.length - _maxLines;
    if (excessCount > 0) {
      _logMessages.removeRange(0, excessCount);
    }
  }

  void setMaxLines(int maxLines) {
    _maxLines = maxLines;
    _removeExcessMessages();
    notifyListeners();
  }
}
