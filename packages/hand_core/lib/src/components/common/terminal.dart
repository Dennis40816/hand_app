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
  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, terminalController, child) {
        return Theme(
          data: widget.theme.themeData,
          child: ListView.builder(
            itemCount: terminalController.terminalData.textSpanList.length,
            itemBuilder: (context, index) {
              return SelectableText.rich(
                  terminalController.terminalData.textSpanList[index]);
            },
          ),
        );
      },
    );
  }
}
