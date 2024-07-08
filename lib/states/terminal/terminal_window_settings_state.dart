import 'package:flutter/material.dart';

class TerminalWindowSettingsParameters {
  final int maxLines;
  final double fontSize;

  TerminalWindowSettingsParameters({
    required this.maxLines,
    required this.fontSize,
  });
}

class TerminalWindowSettingsState with ChangeNotifier {
  TerminalWindowSettingsParameters _parameters;

  TerminalWindowSettingsState(this._parameters);

  double get fontSize => _parameters.fontSize;
  int get maxLines => _parameters.maxLines;

  void setFontSize(double fontSize) {
    _parameters = TerminalWindowSettingsParameters(
      maxLines: _parameters.maxLines,
      fontSize: fontSize,
    );
    notifyListeners();
  }

  void setMaxLines(int maxLines) {
    _parameters = TerminalWindowSettingsParameters(
      maxLines: maxLines,
      fontSize: _parameters.fontSize,
    );
    notifyListeners();
  }
}
