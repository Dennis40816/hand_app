import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/terminal.dart';
import 'hand_log_terminal_controller.dart';
import '../../themes/theme_interface.dart';
import '../../themes/one_dark_pro_theme.dart';
import '../../models/hand/hand_log_message.dart';

class HandLogTerminal extends StatefulWidget {
  final ThemeInterface theme;

  HandLogTerminal({super.key}) : theme = OneDarkProTheme();

  const HandLogTerminal.withTheme(this.theme, {super.key});

  /// Returns the TextStyle for the given log level.
  TextStyle getStyle(HandLogLevel level) {
    switch (level) {
      case HandLogLevel.error:
        return TextStyle(color: theme.red);
      case HandLogLevel.warning:
        return TextStyle(color: theme.yellow);
      case HandLogLevel.info:
        return TextStyle(color: theme.blue);
      case HandLogLevel.debug:
        return TextStyle(color: theme.green);
      case HandLogLevel.verbose:
      default:
        return TextStyle(color: theme.grey);
    }
  }

  @override
  State<HandLogTerminal> createState() => _HandLogTerminalState();
}

class _HandLogTerminalState extends State<HandLogTerminal> {
  late HandLogTerminalController controller;

  /// context is available in didChangeDependencies but not in initState.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<HandLogTerminalController>(context, listen: false);
    controller.setGetStyleFunction(widget.getStyle);
    controller.startUdpReceiver();
  }

  @override
  void dispose() {
    controller.stopUdpReceiver();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Terminal<HandLogTerminalController>(theme: widget.theme);
  }
}
