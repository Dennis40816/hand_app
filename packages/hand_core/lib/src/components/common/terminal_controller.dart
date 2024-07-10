import 'package:flutter/material.dart';
import '../../models/common/terminal_data.dart';

class TerminalController extends ChangeNotifier {
  final TerminalData terminalData = TerminalData(textSpanList: []);
  double fontSize = 18.0;

  /// Adds a new TextSpan to the list and notifies listeners.
  void addTextSpan(TextSpan textSpan) {
    terminalData.data.add(textSpan);
    notifyListeners();
  }

  /// Can be override if user input should transmit through other component
  void addTerminalInput(TextSpan textSpan) {
    /// TODO: should update _shouldAutoScroll
    addTextSpan(textSpan);
  }

  /// Add a new TextSpan List to the list and notifies listeners.
  void addTextSpanList(List<TextSpan> list) {
    terminalData.data.addAll(list);
    notifyListeners();
  }

  /// Clears all TextSpans from the list and notifies listeners.
  void clear() {
    terminalData.data.clear();
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
