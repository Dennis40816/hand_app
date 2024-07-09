import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'terminal_controller.dart';
import '../../themes/theme_interface.dart';

class Terminal<T extends TerminalController> extends StatefulWidget {
  final ThemeInterface theme;

  const Terminal({super.key, required this.theme});

  @override
  State<Terminal<T>> createState() => _TerminalState<T>();
}

class _TerminalState<T extends TerminalController> extends State<Terminal<T>> {
  TextSpan _applyFontSize(TextSpan originalTextSpan, double fontSize) {
    return TextSpan(
      text: originalTextSpan.text,
      style: originalTextSpan.style?.copyWith(fontSize: fontSize) ??
          TextStyle(fontSize: fontSize),
      children: originalTextSpan.children?.map((child) {
        if (child is TextSpan) {
          return _applyFontSize(child, fontSize);
        }
        return child;
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, terminalController, child) {
        return Theme(
          data: widget.theme.themeData,
          child: Container(
            color:
                widget.theme.background, // Set background to theme background
            child: ListView.builder(
              itemCount: terminalController.terminalData.textSpanList.length,
              itemBuilder: (context, index) {
                // Use the method to overwrite the fontSize while keeping other styles
                return SelectableText.rich(
                  _applyFontSize(
                    terminalController.terminalData.textSpanList[index],
                    terminalController.fontSize,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
