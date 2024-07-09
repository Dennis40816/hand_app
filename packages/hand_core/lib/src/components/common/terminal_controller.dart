import 'package:flutter/material.dart';
import '../../models/common/terminal_data.dart';

class TerminalController extends ChangeNotifier {
  final TerminalData terminalData = TerminalData(textSpanList: []);
  double fontSize = 18.0;

  /// Adds a new TextSpan to the list and notifies listeners.
  void addTextSpan(TextSpan textSpan) {
    terminalData.textSpanList.add(textSpan);
    notifyListeners();
  }

  /// Clears all TextSpans from the list and notifies listeners.
  void clear() {
    terminalData.textSpanList.clear();
    notifyListeners();
  }

  /// Updates the maximum number of TextSpans and removes excess TextSpans if necessary.
  void updateMaxTextSpanNum(int newMax) {
    terminalData.updateMaxTextSpanNum(newMax);
    notifyListeners();
  }

  /// Updates the font size and notifies listeners.
  void updateFontSize(double newSize) {
    fontSize = newSize;
    notifyListeners();
  }
}
