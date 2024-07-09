import 'package:flutter/material.dart';
import '../../models/common/terminal_data.dart';

class TerminalController extends ChangeNotifier {
  final TerminalData terminalData = TerminalData(textSpanList: []);

  // Adds a new TextSpan to the list and notifies listeners.
  void addTextSpan(TextSpan textSpan) {
    terminalData.textSpanList.add(textSpan);
    notifyListeners();
  }

  // Clears all TextSpans from the list and notifies listeners.
  void clear() {
    terminalData.textSpanList.clear();
    notifyListeners();
  }
}
