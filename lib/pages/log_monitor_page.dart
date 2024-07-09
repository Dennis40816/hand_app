import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hand_core/hand_core.dart';

class LogMonitorPage extends StatefulWidget {
  const LogMonitorPage({super.key});

  @override
  State<LogMonitorPage> createState() => _LogMonitorPageState();
}

class _LogMonitorPageState extends State<LogMonitorPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Providing HandLogTerminalController to the widget tree
      create: (_) => HandLogTerminalController(UdpReceiver(12345)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Log Monitor')),
        body: Consumer<HandLogTerminalController>(
          builder: (context, terminalController, child) {
            return HandLogTerminal.withTheme(OneDarkProTheme());
          },
        ),
      ),
    );
  }
}
