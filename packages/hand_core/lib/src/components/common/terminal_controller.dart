import 'package:flutter/material.dart';
import 'ip_port_dropdown.dart';
import '../../models/common/terminal_data.dart';

class TerminalController extends ChangeNotifier {
  final TerminalData terminalData = TerminalData(textSpanList: []);

  /// States maintain
  double fontSize = 18.0;
  bool _shouldAutoScroll = true;

  /// HAND IpPortDropdown data
  /// TODO: move to specific terminal instead of here
  List<IpPort> ipPortList = [];

  bool get shouldAutoScroll => _shouldAutoScroll;

  void setShouldAutoScroll(bool value) {
    if (_shouldAutoScroll != value) {
      _shouldAutoScroll = value;
      notifyListeners();
    }
  }

  /// Adds a new TextSpan to the list and notifies listeners.
  void addTextSpan(TextSpan textSpan) {
    terminalData.data.add(textSpan);
    notifyListeners();
  }

  /// Can be override if user input should transmit through other component
  void addTerminalInput(TextSpan textSpan, [String? showPrefix]) {
    // Get the original text from the provided TextSpan
    final originalText = textSpan.text ?? '';

    // Combine the prefix (if any) with the original text
    final combinedText = (showPrefix ?? '') + originalText;

    // Create a new TextSpan with the combined text and the same style as the original
    final prefixTextSpan = TextSpan(
      text: combinedText,
      style: textSpan.style,
    );

    // Activate auto scroll when user input new data
    setShouldAutoScroll(true);
    addTextSpan(prefixTextSpan);
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
