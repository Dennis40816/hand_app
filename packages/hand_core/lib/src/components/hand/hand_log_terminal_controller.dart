import 'package:flutter/material.dart';
import '../../network/udp_receiver.dart';
import '../../parser/hand_log_parser.dart';
import '../../models/hand/hand_log_message.dart';
import '../common/terminal_controller.dart';

import 'package:logger/logger.dart';

class HandLogTerminalController extends TerminalController {
  final UdpReceiver udpReceiver;
  final HandLogParser logParser = HandLogParser();
  List<HandLogMessage> messageQueue = [];
  late TextStyle Function(HandLogLevel) getStyle;

  HandLogTerminalController(this.udpReceiver);

  /// Translates messages in the queue to TextSpans and notifies listeners.
  void translateMessages() {
    List<TextSpan> newSpans = [];
    for (var message in messageQueue) {
      newSpans.add(
          TextSpan(text: message.toString(), style: getStyle(message.level)));
    }
    messageQueue.clear();
    terminalData.textSpanList.addAll(newSpans);
    notifyListeners();
  }

  /// Starts the UDP receiver and listens for incoming messages.
  void startUdpReceiver() {
    udpReceiver.startListening();
    udpReceiver.onData.listen((data) {
      HandLogMessage message = logParser.parseLog(data);
      messageQueue.add(message);
      translateMessages();
      notifyListeners();
    });
  }

  /// Stops the UDP receiver.
  void stopUdpReceiver() {
    udpReceiver.stopListening();
  }

  /// Returns the current list of messages in the queue.
  List<HandLogMessage> getMessages() {
    return messageQueue;
  }

  /// Clears the message queue.
  void clearMessages() {
    messageQueue.clear();
  }

  /// Sets the function to get the TextStyle for each log level.
  void setGetStyleFunction(TextStyle Function(HandLogLevel) styleFunction) {
    getStyle = styleFunction;
  }
}
