import 'package:flutter/material.dart';
import 'package:hand_core/hand_core.dart';
import '../components/terminal_window.dart';

class LogMonitorPage extends StatefulWidget {
  @override
  _LogMonitorPageState createState() => _LogMonitorPageState();
}

class _LogMonitorPageState extends State<LogMonitorPage> {
  final HandMainUdpLogReceiver _udpLogReceiver =
      HandMainUdpLogReceiver(port: 12345);
  int _maxLines = 500; // Default max lines

  @override
  void initState() {
    super.initState();
    _udpLogReceiver.startListening();
  }

  @override
  void dispose() {
    _udpLogReceiver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HAND MAIN UDP Log Monitor'),
      ),
      body: Stack(
        children: [
          const Center(child: Text('Main Content Here')),
          TerminalWindow(udpLogReceiver: _udpLogReceiver, maxLines: _maxLines),
        ],
      ),
    );
  }
}
