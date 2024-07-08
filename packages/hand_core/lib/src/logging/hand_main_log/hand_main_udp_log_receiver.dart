import 'dart:async';
import 'package:udp/udp.dart';
import 'hand_main_log_message.dart';
import 'hand_main_log_parser.dart';
import 'package:logger/logger.dart';

// debug usage
var logger = Logger(
  printer: PrettyPrinter(),
);

class HandMainUdpLogReceiver {
  final int port;
  late UDP _receiver;
  final StreamController<HandMainLogMessage> _logStreamController =
      StreamController<HandMainLogMessage>();
  final HandMainLogParser _logParser = HandMainLogParser();

  HandMainUdpLogReceiver({required this.port});

  Stream<HandMainLogMessage> get logStream => _logStreamController.stream;

  Future<void> startListening() async {
    _receiver = await UDP.bind(Endpoint.any(port: Port(port)));
    logger.i('Start to listening UDP at port: $port');
    await _receiver.asStream().forEach((datagram) {
      if (datagram != null) {
        String message = String.fromCharCodes(datagram.data);
        HandMainLogMessage logMessage = _logParser.parseLog(message);
        _logStreamController.add(logMessage);
      }
    });
  }

  void dispose() {
    _receiver.close();
    _logStreamController.close();
  }
}
