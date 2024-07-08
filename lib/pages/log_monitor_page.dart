import 'package:flutter/material.dart';
import 'package:hand_app/components/hand/hand_log_terminal.dart';

class LogMonitorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HAND MAIN UDP Log Monitor'),
      ),
      body: const Stack(
        children: [
          Center(child: Text('Main Content Here')),
          HandLogTerminal(udpPort: 12345),
        ],
      ),
    );
  }
}
