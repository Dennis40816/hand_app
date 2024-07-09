import 'package:flutter/material.dart';

class TerminalData {
  List<TextSpan> textSpanList;
  int maxTextSpanNum;

  /// get
  int get length => textSpanList.length;
  List<TextSpan> get data => textSpanList;

  TerminalData({required this.textSpanList, this.maxTextSpanNum = 500});

  /// Updates the maximum number of TextSpans and removes excess TextSpans if necessary.
  void updateMaxTextSpanNum(int newMax) {
    if (newMax < 0) {
      throw ArgumentError('maxTextSpanNum cannot be negative');
    }
    maxTextSpanNum = newMax;
    if (textSpanList.length > maxTextSpanNum) {
      textSpanList.removeRange(0, textSpanList.length - maxTextSpanNum);
    }
  }
}
