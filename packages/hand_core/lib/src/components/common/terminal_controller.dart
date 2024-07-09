import 'package:flutter/material.dart';
import '../../models/common/terminal_data.dart';

class TerminalController extends ChangeNotifier {
  final TerminalData terminalData = TerminalData(textSpanList: []);

  void addTextSpan(TextSpan textSpan) {
    terminalData.textSpanList.add(textSpan);
    notifyListeners();
  }

  void clear() {
    terminalData.textSpanList.clear();
    notifyListeners();
  }
}
