import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hand_app/components/terminal/terminal_window.dart';
import 'package:hand_app/themes/one_dark_pro_theme.dart';
import 'package:hand_app/states/log/log_data_state.dart';
import 'package:hand_core/hand_core.dart';
import 'package:logger/logger.dart';
import 'dart:async';

// debug usage
var logger = Logger(
  printer: PrettyPrinter(),
);

class HandLogTerminal extends StatefulWidget {
  final int udpPort;

  const HandLogTerminal({Key? key, required this.udpPort}) : super(key: key);

  @override
  _HandLogTerminalState createState() => _HandLogTerminalState();
}

class _HandLogTerminalState extends State<HandLogTerminal> {
  late HandMainUdpLogReceiver _udpLogReceiver;
  StreamSubscription<HandMainLogMessage>? _logSubscription;

  @override
  void initState() {
    super.initState();
    _udpLogReceiver = HandMainUdpLogReceiver(port: widget.udpPort);
    _udpLogReceiver.startListening();

    // Use Future.microtask to ensure the context is ready
    Future.microtask(() {
      _logSubscription = _udpLogReceiver.logStream.listen((message) {
        logger.d("got $message");
        context
            .read<LogDataState<HandMainLogMessage, HandMainLogLevel>>()
            .appendMessage(message);
      });
    });
  }

  @override
  void dispose() {
    _logSubscription?.cancel();
    _udpLogReceiver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<
            LogDataState<HandMainLogMessage, HandMainLogLevel>>(
          create: (_) => LogDataState<HandMainLogMessage, HandMainLogLevel>(),
        ),
        Provider<HandMainUdpLogReceiver>(
          create: (_) => _udpLogReceiver,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('HAND Main Log Terminal'),
        ),
        body: TerminalWindow(
          theme: OneDarkProTheme(),
        ),
      ),
    );
  }
}
